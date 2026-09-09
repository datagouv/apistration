ENV['RAILS_ENV'] = 'test'

require 'rails'
require 'active_support/all'
require 'active_support/cache/redis_cache_store'
require 'redis'
require 'webmock'
require 'rspec/expectations'
require 'timecop'
require 'zeitwerk'
require 'tmpdir'
require 'timeout'
require 'singleton'
require_relative 'simulated_insee'

$stdout.sync = true

class INSEESmoke
  include RSpec::Matchers

  STATIC_PASSWORD = 'Static-Password1'.freeze
  PREVIOUS_PASSWORD = '2AiKRY3mRq0NERC_'.freeze
  CURRENT_PASSWORD = 's-ughRpOLNf6dL7E'.freeze
  BYPASS_PASSWORD = 'Bypass-Password1'.freeze
  OAUTH_URL = 'https://auth.insee.net/auth/realms/apim-gravitee/protocol/openid-connect/token'.freeze
  API_URL = 'https://api.insee.fr/api-sirene/prive/3.11'.freeze

  attr_reader :provider, :alerts, :state, :socket, :scenarios, :credentials

  def self.run
    previous_term_handler = Signal.trap('TERM') { raise Interrupt }
    suite = new
    suite.start
    yield suite
    puts "\n#{suite.scenarios} scénarios validés ; aucun appel HTTP réel, aucune base applicative utilisée."
  ensure
    suite&.stop
    Signal.trap('TERM', previous_term_handler) if previous_term_handler
  end

  def start
    @scenarios = 0
    @alerts = []
    WebMock.enable!
    WebMock.disable_net_connect!
    start_redis
    load_application_classes
    reset
    puts "#{application_name} : classes applicatives réelles, Redis éphémère, INSEE simulé avec état."
  end

  def stop
    Timecop.return
    Process.kill('TERM', @redis_pid) if @redis_pid
    Process.wait(@redis_pid) if @redis_pid
  rescue Errno::ESRCH, Errno::ECHILD
    nil
  ensure
    FileUtils.remove_entry(@directory) if @directory
  end

  def scenario(name)
    reset
    yield
    @scenarios += 1
    puts "OK #{name}"
  rescue StandardError, RSpec::Expectations::ExpectationNotMetError
    warn "ÉCHEC #{name}"
    raise
  end

  def reset
    Timecop.freeze(Time.new(2027, 1, 15, 12, 0, 0, '+01:00'))
    Time.zone = 'Europe/Paris'
    Rails.env = 'test'
    @cache_redis.flushdb
    @state.flushdb
    @alerts.clear
    credentials.delete(INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY)
    reconnect_cache
    @provider = SimulatedINSEE.new(@state)
    @provider.password = CURRENT_PASSWORD
    WebMock.reset!
    WebMock.stub_request(:post, OAUTH_URL).to_return { |request| @provider.authenticate(request) }
    WebMock.stub_request(:post, "#{API_URL}/renouvellement").to_return { |request| @provider.renew(request) }
    WebMock.stub_request(:get, %r{\A#{Regexp.escape(API_URL)}/(?:siren|siret)/}).to_return { |request| @provider.resource(request) }
  end

  def reconnect_cache(namespace: "#{application_name}-smoke")
    Rails.cache = ActiveSupport::Cache::RedisCacheStore.new(
      url: "unix://#{socket}", namespace:,
      error_handler: ->(exception:, **) { raise exception }
    )
  end

  def guard_active?
    @cache_redis.exists?('insee:auth_failed')
  end

  def use_bypass
    credentials[INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY] = BYPASS_PASSWORD
  end

  def disconnect_cache
    Rails.cache = ActiveSupport::Cache::RedisCacheStore.new(
      url: "unix://#{socket}.missing", error_handler: ->(**) {}
    )
  end

  def before_cache_removal(action)
    Rails.cache.redis.then do |redis|
      original = redis.method(:send_command)
      pending = true
      redis.define_singleton_method(:send_command) do |command, &block|
        if pending && %w[del unlink eval].include?(command.first.to_s.downcase)
          pending = false
          action.call
        end
        original.call(command, &block)
      end
      yield
      expect(pending).to be(false)
    ensure
      redis.singleton_class.remove_method(:send_command)
    end
  end

  def concurrent_workers(&operation)
    children = []
    8.times do
      children << fork do
        reconnect_cache
        Time.zone = 'Europe/Paris'
        state.incr('workers_ready')
        wait_until { state.get('workers_go') == '1' }
        Rails.cache.with_local_cache(&operation)
        exit! 0
      rescue StandardError, RSpec::Expectations::ExpectationNotMetError => e
        warn "Worker: #{e.class}: #{e.message}"
        exit! 1
      end
    end
    wait_until { state.get('workers_ready').to_i == children.size }
    state.set('workers_go', '1')
    statuses = Timeout.timeout(10) { children.map { |pid| Process.wait2(pid).last } }
    children.clear
    expect(statuses).to all(be_success)
  ensure
    children&.each do |pid|
      Process.kill('KILL', pid)
      Process.wait(pid)
    rescue Errno::ESRCH, Errno::ECHILD
      next
    end
  end

  def assert_concurrent_authentication
    provider.oauth_delay = 0.15
    concurrent_workers { state.rpush('worker_tokens', authenticate) }
    expect(state.lrange('worker_tokens', 0, -1)).to eq(Array.new(8, published_token))
    expect(provider.attempts).to eq([CURRENT_PASSWORD])
    expect(lock_value).to be_nil
  end

  def common_scenarios
    scenario('dérivation : statique avant novembre, valeurs connues en novembre et janvier') do
      expect(INSEE::PasswordDerivation.current_password).to eq(CURRENT_PASSWORD)
      expect(INSEE::PasswordDerivation.previous_password).to eq(PREVIOUS_PASSWORD)
      Timecop.freeze(Time.new(2026, 10, 31, 12, 0, 0, '+01:00'))
      expect(INSEE::PasswordDerivation.candidates).to eq([STATIC_PASSWORD])
      Timecop.freeze(Time.new(2026, 11, 1, 12, 0, 0, '+01:00'))
      expect(INSEE::PasswordDerivation.candidates).to eq([PREVIOUS_PASSWORD, STATIC_PASSWORD])
    end

    scenario('retard de rotation : repli sur le précédent, puis réutilisation du token') do
      provider.password = PREVIOUS_PASSWORD
      token = authenticate
      expect(authenticate).to eq(token)
      expect(provider.attempts).to eq([CURRENT_PASSWORD, PREVIOUS_PASSWORD])
      expect(guard_active?).to be(false)
    end

    scenario('rotation pendant les tentatives : courant → précédent → courant accepté') do
      provider.password = 'Unknown-Password1'
      provider.after_oauth = -> { provider.password = CURRENT_PASSWORD }
      expect(authenticate).to eq(published_token)
      expect(provider.attempts).to eq([CURRENT_PASSWORD, PREVIOUS_PASSWORD, CURRENT_PASSWORD])
      expect(alerts).to be_empty
      expect(guard_active?).to be(false)
    end

    scenario('désynchronisation : trois essais puis garde-fou de 30 minutes, même après redémarrage') do
      provider.password = 'Unknown-Password1'
      expect_rejection
      expect(provider.attempts.size).to eq(3)
      expect(@cache_redis.ttl('insee:auth_failed')).to be_between(1790, 1800)
      reconnect_cache(namespace: 'another-boot')
      expect_temporary_failure
      expect(provider.attempts.size).to eq(3)
      expect(alerts.size).to eq(1)
      provider.password = CURRENT_PASSWORD
      clear_guards
      expect(authenticate).to eq(published_token)
      expect(provider.attempts.size).to eq(4)
    end

    [408, 429, 500, 503, :timeout].each do |fault|
      scenario("OAuth #{fault} : un seul essai, aucun garde-fou, reprise immédiate") do
        provider.oauth_fault = fault
        expect_temporary_failure
        expect(provider.attempts.size).to eq(1)
        expect(guard_active?).to be(false)
        expect(alerts).to be_empty
        provider.oauth_fault = nil
        expect(authenticate).to eq(published_token)
        expect(provider.attempts.size).to eq(2)
      end
    end

    scenario('invalid_client : arrêt au premier refus et activation du garde-fou') do
      provider.oauth_fault = :invalid_client
      expect_rejection
      expect(provider.attempts.size).to eq(1)
      expect(guard_active?).to be(true)
    end

    scenario('expiration du garde-fou : reprise après trente minutes sans intervention') do
      provider.password = 'Unknown-Password1'
      expect_rejection
      provider.password = CURRENT_PASSWORD
      Timecop.freeze(Time.current + 30.minutes + 1.second)
      expect(authenticate).to eq(published_token)
      expect(provider.attempts.size).to eq(4)
      expect(guard_active?).to be(false)
    end

    scenario('Redis indisponible : authentification directe sans attendre un verrou inexistant') do
      disconnect_cache
      expect(authenticate).to start_with('smoke-token-')
      expect(provider.attempts).to eq([CURRENT_PASSWORD])
      expect { invalidate('rejected-token') }.not_to raise_error
    end

    scenario('Redis indisponible sous concurrence : huit échanges indépendants') do
      concurrent_workers do
        disconnect_cache
        expect(authenticate).to start_with('smoke-token-')
      end
      expect(provider.attempts).to eq(Array.new(8, CURRENT_PASSWORD))
    end

    scenario('garde-fou actif : un token déjà publié reste utilisable') do
      token = authenticate
      Rails.cache.write('auth_failed', true, namespace: 'insee', expires_in: 30.minutes)
      expect(authenticate).to eq(token)
      expect(fetch_resource).not_to be_empty
      expect(provider.attempts).to eq([CURRENT_PASSWORD])
    end

    scenario('token expiré : nouvel échange OAuth après la marge de dix secondes') do
      token = authenticate
      Timecop.freeze(Time.current + 3591.seconds)
      expect(authenticate).not_to eq(token)
      expect(provider.attempts).to eq([CURRENT_PASSWORD, CURRENT_PASSWORD])
    end

    scenario('bypass : accepté en priorité, puis repli après changement du mot de passe INSEE') do
      use_bypass
      provider.password = BYPASS_PASSWORD
      token = authenticate
      provider.password = CURRENT_PASSWORD
      invalidate(token)
      authenticate
      expect(provider.attempts).to eq([BYPASS_PASSWORD, BYPASS_PASSWORD, CURRENT_PASSWORD])
    end

    scenario('bypass refusé : deux essais seulement') do
      use_bypass
      provider.password = 'Unknown-Password1'
      expect_rejection
      expect(provider.attempts).to eq([BYPASS_PASSWORD, CURRENT_PASSWORD])
    end

    scenario('mot de passe statique refusé : un seul essai avant novembre') do
      Timecop.freeze(Time.new(2026, 10, 31, 12, 0, 0, '+01:00'))
      provider.password = 'Unknown-Password1'
      expect_rejection
      expect(provider.attempts).to eq([STATIC_PASSWORD])
    end

    scenario('huit processus simultanés : un seul échange OAuth et le même token') do
      assert_concurrent_authentication
    end

    scenario('huit processus désynchronisés : trois essais au total puis garde-fou') do
      provider.password = 'Unknown-Password1'
      provider.oauth_delay = 0.1
      concurrent_workers { state.rpush('outcomes', authentication_outcome) }
      expect(state.lrange('outcomes', 0, -1)).to contain_exactly('rejected', *Array.new(7, 'temporary'))
      expect(provider.attempts).to eq([CURRENT_PASSWORD, PREVIOUS_PASSWORD, CURRENT_PASSWORD])
      expect(guard_active?).to be(true)
      expect(lock_value).to be_nil
    end

    scenario('huit processus face à un 503 : un seul essai puis reprise possible') do
      provider.oauth_fault = 503
      provider.oauth_delay = 0.15
      concurrent_workers { expect_temporary_failure }
      expect(provider.attempts).to eq([CURRENT_PASSWORD])
      expect(guard_active?).to be(false)
      expect(lock_value).to be_nil
      provider.oauth_fault = nil
      expect(authenticate).to eq(published_token)
    end

    scenario('OAuth lent : les concurrents échouent temporairement sans multiplier les essais') do
      provider.oauth_delay = 0.75
      concurrent_workers { state.rpush('outcomes', authentication_outcome) }
      expect(state.lrange('outcomes', 0, -1)).to contain_exactly('granted', *Array.new(7, 'temporary'))
      expect(authenticate).to eq(published_token)
      expect(provider.attempts).to eq([CURRENT_PASSWORD])
      expect(guard_active?).to be(false)
    end

    scenario('huit 401 simultanés : un seul nouveau token et huit requêtes rétablies') do
      rejected = authenticate
      provider.revoke_tokens
      provider.oauth_delay = 0.15
      provider.before_resource = lambda do
        wait_until { state.get('resources_ready').to_i >= 8 } if state.incr('resources_ready') <= 8
      end
      concurrent_workers { expect(fetch_resource).not_to be_empty }
      expect(provider.bearers.count("Bearer #{rejected}")).to eq(8)
      expect(provider.bearers.count("Bearer #{published_token}")).to eq(8)
      expect(provider.attempts).to eq([CURRENT_PASSWORD, CURRENT_PASSWORD])
      expect(lock_value).to be_nil
    end

    scenario('verrou abandonné : expiration dans Redis puis reprise') do
      write_lock('dead-worker')
      key = @cache_redis.keys('*auth_lock').sole
      @cache_redis.pexpire(key, 50)
      wait_until { !@cache_redis.exists?(key) }
      expect(authenticate).to eq(published_token)
      expect(provider.attempts).to eq([CURRENT_PASSWORD])
      expect(lock_value).to be_nil
    end

    scenario('démarrages distincts : le nombre d’échanges dépend du namespace du token') do
      provider.oauth_delay = 0.15
      concurrent_workers do
        reconnect_cache(namespace: "boot-#{Process.pid}")
        Rails.cache.with_local_cache { expect(authenticate).to start_with('smoke-token-') }
      end
      expected_attempts = application_name == 'siade' ? 8 : 1
      expect(provider.attempts).to eq(Array.new(expected_attempts, CURRENT_PASSWORD))
    end

    scenario('verrou repris pendant OAuth : le premier propriétaire ne le supprime pas') do
      provider.after_oauth = -> { Rails.cache.with_local_cache { write_lock('successor') } }
      Rails.cache.with_local_cache { authenticate }
      expect(lock_value).to eq('successor')
    end

    scenario('token remplacé entre comparaison et suppression : le nouveau token est conservé') do
      rejected = authenticate
      replacement = provider.issue_token
      before_cache_removal(-> { Rails.cache.with_local_cache { cache_token(replacement) } }) do
        Rails.cache.with_local_cache { invalidate(rejected) }
      end
      expect(published_token).to eq(replacement)
    end

    scenario('verrou repris entre comparaison et suppression : le successeur reste propriétaire') do
      before_cache_removal(-> { Rails.cache.with_local_cache { write_lock('successor') } }) do
        Rails.cache.with_local_cache { authenticate }
      end
      expect(lock_value).to eq('successor')
    end
  end

  private

  def start_redis
    @directory = Dir.mktmpdir('insee-smoke-', '/tmp')
    @socket = File.join(@directory, 'redis.sock')
    @redis_pid = Process.spawn(
      'redis-server', '--port', '0', '--unixsocket', @socket,
      '--unixsocketperm', '700', '--save', '', '--appendonly', 'no',
      '--dir', @directory, out: File.join(@directory, 'redis.log'), err: %i[child out]
    )
    @cache_redis = Redis.new(path: @socket)
    @state = Redis.new(path: @socket, db: 1)
    wait_until do
      @cache_redis.ping == 'PONG'
    rescue Redis::CannotConnectError
      false
    end
  end

  def wait_until
    Timeout.timeout(5) do
      sleep(0.01) until yield
    end
  end

  def load_application_classes
    application_root = File.expand_path("../../../#{application_name}", __dir__)
    Rails.application = Class.new(Rails::Application).new
    Rails.application.config.root = application_root
    Rails.logger = Logger.new(File::NULL)
    require File.join(application_root, 'config/initializers/inflections')
    @credentials = {
      insee_apim_password: STATIC_PASSWORD, insee_password: STATIC_PASSWORD,
      insee_apim_password_derivation_key: 'known-vector-derivation-key',
      insee_password_derivation_key: 'known-vector-derivation-key',
      insee_sirene_client_id: 'smoke-client', insee_client_id: 'smoke-client',
      insee_sirene_client_secret: 'smoke-secret', insee_client_secret: 'smoke-secret',
      insee_apim_username: 'smoke-user', insee_username: 'smoke-user',
      insee_oauth_url: OAUTH_URL, insee_sirene_url: 'https://api.insee.fr',
      encrypted_cache_salt_key: 'smoke-salt'
    }
    container = Object.const_set(application_name == 'siade' ? 'Siade' : 'AdminApientreprise', Module.new)
    container.define_singleton_method(:credentials) { @smoke_credentials }
    container.instance_variable_set(:@smoke_credentials, @credentials)
    @loader = Zeitwerk::Loader.new
    @loader.inflector.define_singleton_method(:camelize) { |basename, _path| basename.camelize }
    source_directories.each { |directory| @loader.push_dir(File.join(application_root, 'app', directory)) }
    @loader.setup
    captured_alerts = @alerts
    MonitoringService.instance.define_singleton_method(:track) do |*arguments, **options|
      captured_alerts << [arguments, options]
    end
  end
end
