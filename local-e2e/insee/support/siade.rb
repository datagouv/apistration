require_relative 'support'
require 'interactor'
require 'lockbox'

Lockbox.master_key = Lockbox.generate_key

class SIADEINSEESmoke < INSEESmoke
  class ProviderFailure < StandardError
    attr_reader :context

    def initialize(context)
      @context = context
      super(context.errors.map { |error| error.class.name }.join(', '))
    end
  end

  def application_name
    'siade'
  end

  def source_directories
    %w[errors services lib interactors interactors/concerns]
  end

  def authenticate
    result = INSEE::Authenticate.call(provider_name: 'INSEE')
    raise ProviderFailure, result unless result.success?

    result.token
  end

  def published_token
    INSEE::Authenticate.published_token
  end

  def authentication_outcome
    authenticate
    'granted'
  rescue ProviderFailure => e
    e.context.errors.first.code == '01006' ? 'rejected' : 'temporary'
  end

  def cache_token(token)
    EncryptedCache.write(INSEE::Authenticate::CACHE_KEY, token, expires_in: 1.hour)
  end

  def invalidate(token)
    INSEE::Authenticate.invalidate_token_cache!(token)
  end

  def before_derivation
    Timecop.freeze(Time.new(2026, 10, 15, 12, 0, 0, '+02:00'))
    provider.password = STATIC_PASSWORD
  end

  def alert_messages
    alerts.map(&:first)
  end

  def first_refusal_hold
    30.seconds
  end

  def clear_guards
    INSEE::Authenticate.clear_guards!
  end

  def lock_value
    Rails.cache.read(INSEE::Authenticate::LOCK_CACHE_KEY)
  end

  def write_lock(owner)
    Rails.cache.write(INSEE::Authenticate::LOCK_CACHE_KEY, owner, expires_in: 90)
  end

  def expect_rejection
    expect { authenticate }.to raise_error(ProviderFailure) do |failure|
      expect(failure.context.errors.map(&:code)).to eq(['01006'])
    end
  end

  def expect_temporary_failure
    expect { authenticate }.to raise_error(ProviderFailure) do |failure|
      expect(failure.context.errors.size).to eq(1)
      expect(%w[01001 01002 01011]).to include(failure.context.errors.first.code)
    end
  end

  def fetch_resource
    result = INSEE::UniteLegale::MakeRequest.call(
      provider_name: 'INSEE', params: { siren: '123456789' }, token: authenticate
    )
    raise ProviderFailure, result unless result.success?

    JSON.parse(result.response.body).fetch('uniteLegale')
  end

  def siade_scenarios
    scenario('rotation externe : ancien token refusé, réauthentification et Sirene accessible') do
      provider.password = PREVIOUS_PASSWORD
      expect(fetch_resource).to include('siren' => '123456789')
      token = published_token
      provider.password = CURRENT_PASSWORD
      provider.revoke_tokens
      expect(fetch_resource).to include('siren' => '123456789')
      expect(provider.attempts).to eq([CURRENT_PASSWORD, PREVIOUS_PASSWORD, CURRENT_PASSWORD])
      expect(provider.bearers).to eq(["Bearer #{token}", "Bearer #{token}", "Bearer #{published_token}"])
      expect(provider.renewals).to eq(0)
    end

    scenario('401 tardif sous LocalCache : conservation du token publié par une autre requête') do
      Rails.cache.with_local_cache do
        token = authenticate
        EncryptedCache.read(INSEE::Authenticate::CACHE_KEY)
        provider.before_resource = lambda do
          provider.before_resource = nil
          provider.revoke_tokens
          Rails.cache.with_local_cache { cache_token(provider.issue_token) }
        end
        expect(fetch_resource).to include('siren' => '123456789')
        expect(published_token).not_to eq(token)
      end
      expect(provider.attempts).to eq([CURRENT_PASSWORD])
      expect(provider.bearers.size).to eq(2)
    end

    scenario('401 sous LocalCache après suppression concurrente : ancien token jamais rejoué') do
      Rails.cache.with_local_cache do
        token = authenticate
        EncryptedCache.read(INSEE::Authenticate::CACHE_KEY)
        provider.before_resource = lambda do
          provider.before_resource = nil
          provider.revoke_tokens
          Rails.cache.with_local_cache { invalidate(token) }
        end
        expect(fetch_resource).to include('siren' => '123456789')
        expect(provider.bearers).to eq(["Bearer #{token}", "Bearer #{published_token}"])
      end
      expect(provider.attempts).to eq([CURRENT_PASSWORD, CURRENT_PASSWORD])
    end

    scenario('deux 401 successifs : un seul rejeu et erreur 01011 avec retry_in=10') do
      provider.reject_resources = true
      expect { fetch_resource }.to raise_error(ProviderFailure) do |failure|
        expect(failure.context.errors.map(&:code)).to eq(['01011'])
        expect(failure.context.errors.first.meta).to include(retry_in: 10)
      end
      expect(provider.bearers.size).to eq(2)
      expect(provider.attempts.size).to eq(2)
    end

    scenario('mot de passe changé hors rotation après un 401 : erreur 01006 propagée, un seul essai du courant déjà accepté') do
      authenticate
      provider.password = 'Unknown-Password1'
      provider.revoke_tokens
      expect { fetch_resource }.to raise_error(ProviderFailure) do |failure|
        expect(failure.context.errors.map(&:code)).to eq(['01006'])
      end
      expect(provider.bearers.size).to eq(1)
      expect(provider.attempts).to eq([CURRENT_PASSWORD, CURRENT_PASSWORD])
      expect(guard_active?).to be(true)
    end

    scenario('renouvellement anticipé : token courant jusqu’à 90 s de l’expiration, puis nouveau token') do
      started_at = Time.current
      token = authenticate
      Timecop.freeze(started_at + 209.seconds)
      expect(authenticate).to eq(token)
      expect(provider.attempts.size).to eq(1)
      Timecop.freeze(started_at + 211.seconds)
      renewed = authenticate
      expect(renewed).not_to eq(token)
      expect(published_token).to eq(renewed)
      expect(fetch_resource).to include('siren' => '123456789')
      expect(provider.attempts.size).to eq(2)
      expect(lock_value).to be_nil
    end

    scenario('refus intermittent au renouvellement : aucune requête en échec, nouveau token 30 s après') do
      before_derivation
      started_at = Time.current
      token = authenticate
      Timecop.freeze(started_at + 211.seconds)
      provider.refuse_next_logins(1)
      expect(fetch_resource).to include('siren' => '123456789')
      expect(published_token).to eq(token)
      Timecop.freeze(started_at + 240.seconds)
      expect(fetch_resource).to include('siren' => '123456789')
      expect(provider.attempts.size).to eq(2)
      Timecop.freeze(started_at + 242.seconds)
      expect(authenticate).not_to eq(token)
      expect(provider.attempts.size).to eq(3)
      expect(provider.bearers).to all(eq("Bearer #{token}"))
      expect(alert_messages).to eq(
        [['error', 'INSEE refused the only password candidate: intermittent refusal or account locked'],
         ['warning', 'INSEE authentication recovered']]
      )
    end

    scenario('refus isolé sans token : 01006, suspension de 30 s puis reprise, une alerte et un retour') do
      before_derivation
      started_at = Time.current
      provider.refuse_next_logins(1)
      expect_rejection
      Timecop.freeze(started_at + 29.seconds)
      expect_temporary_failure
      expect(provider.attempts.size).to eq(1)
      Timecop.freeze(started_at + 31.seconds)
      expect(fetch_resource).to include('siren' => '123456789')
      expect(provider.attempts.size).to eq(2)
      expect(alert_messages.map(&:first)).to eq(%w[error warning])
    end

    scenario('refus prolongé : suspensions de 30 s, 1, 2, 4 puis 5 min, une seule alerte') do
      before_derivation
      provider.refuse_next_logins(100)
      expect_rejection
      [30, 60, 120, 240, 300, 300].each.with_index(2) do |hold, attempts|
        Timecop.freeze(Time.current + hold - 1)
        expect_temporary_failure
        expect(provider.attempts.size).to eq(attempts - 1)
        Timecop.freeze(Time.current + 2)
        expect_rejection
        expect(provider.attempts.size).to eq(attempts)
      end
      provider.refuse_next_logins(0)
      Timecop.freeze(Time.current + 301)
      expect(fetch_resource).to include('siren' => '123456789')
      expect(alert_messages.map(&:first)).to eq(%w[error warning])
      expect(alerts.last.first).to eq(['warning', 'INSEE authentication recovered'])
    end

    scenario('compte désactivé par Keycloak : backoff ordinaire et une seule alerte') do
      before_derivation
      provider.account_status = 'Account disabled'
      expect_rejection
      Timecop.freeze(Time.current + 31.seconds)
      expect_rejection
      expect(provider.attempts.size).to eq(2)
      expect(alert_messages.map(&:first)).to eq(%w[error])
    end

    scenario('OAuth indisponible après novembre, précédent accepté en dernier : une seule tentative, le parcours des candidats devant finir avant l’expiration') do
      provider.password = PREVIOUS_PASSWORD
      started_at = Time.current
      token = authenticate
      provider.oauth_fault = 503
      Timecop.freeze(started_at + 211.seconds)
      3.times { expect(fetch_resource).to include('siren' => '123456789') }
      Timecop.freeze(started_at + 242.seconds)
      expect(authenticate).to eq(token)
      expect(provider.attempts.size).to eq(3)
    end

    scenario('OAuth indisponible après novembre, courant accepté en dernier : deux tentatives, un seul échange à prévoir') do
      started_at = Time.current
      token = authenticate
      provider.oauth_fault = 503
      Timecop.freeze(started_at + 211.seconds)
      3.times { expect(fetch_resource).to include('siren' => '123456789') }
      Timecop.freeze(started_at + 242.seconds)
      expect(authenticate).to eq(token)
      expect(provider.attempts.size).to eq(3)
      Timecop.freeze(started_at + 275.seconds)
      expect(authenticate).to eq(token)
      expect(provider.attempts.size).to eq(3)
    end

    scenario('OAuth indisponible pendant le renouvellement : une tentative toutes les 30 s, pas une par requête') do
      before_derivation
      started_at = Time.current
      token = authenticate
      provider.oauth_fault = 503
      Timecop.freeze(started_at + 211.seconds)
      5.times { expect(fetch_resource).to include('siren' => '123456789') }
      expect(provider.attempts.size).to eq(2)
      Timecop.freeze(started_at + 242.seconds)
      expect(authenticate).to eq(token)
      expect(provider.attempts.size).to eq(3)
      Timecop.freeze(started_at + 275.seconds)
      expect(authenticate).to eq(token)
      expect(provider.attempts.size).to eq(3)
      expect(guard_active?).to be(false)
    end

    scenario('refus intermittent après novembre, sans courant accepté : le précédent est essayé et refusé avant le courant') do
      provider.refuse_next_logins(1)
      authenticate
      expect(provider.attempts).to eq([CURRENT_PASSWORD, PREVIOUS_PASSWORD, CURRENT_PASSWORD])
      expect(alerts).to be_empty
    end

    scenario('refus intermittent après novembre, courant déjà accepté : le précédent n’est pas essayé, reprise après 30 s') do
      started_at = Time.current
      authenticate
      Timecop.freeze(started_at + 5.minutes)
      provider.refuse_next_logins(1)
      expect_rejection
      expect(provider.attempts).to eq([CURRENT_PASSWORD, CURRENT_PASSWORD])
      Timecop.freeze(started_at + 5.minutes + 31.seconds)
      expect(fetch_resource).to include('siren' => '123456789')
      expect(provider.attempts).to eq([CURRENT_PASSWORD] * 3)
      expect(alert_messages).to eq(
        [['error', 'INSEE refused the current password it accepted last: intermittent refusal, account locked or password changed outside the rotation'],
         ['warning', 'INSEE authentication recovered']]
      )
    end

    scenario('nouveau bimestre avant la rotation : parcours complet tant que le nouveau courant n’a pas été accepté') do
      Timecop.freeze(Time.new(2026, 12, 31, 23, 50, 0, '+01:00'))
      provider.password = PREVIOUS_PASSWORD
      authenticate
      Timecop.freeze(Time.new(2027, 1, 1, 0, 1, 0, '+01:00'))
      authenticate
      expect(provider.attempts).to eq([PREVIOUS_PASSWORD, CURRENT_PASSWORD, PREVIOUS_PASSWORD])
      provider.password = CURRENT_PASSWORD
      Timecop.freeze(Time.new(2027, 1, 1, 0, 7, 0, '+01:00'))
      authenticate
      Timecop.freeze(Time.new(2027, 1, 1, 0, 13, 0, '+01:00'))
      provider.refuse_next_logins(1)
      expect_rejection
      expect(provider.attempts.drop(3)).to eq([CURRENT_PASSWORD, CURRENT_PASSWORD])
    end

    scenario('Redis indisponible après novembre : parcours complet faute de savoir quel mot de passe a été accepté') do
      authenticate
      disconnect_cache
      provider.refuse_next_logins(1)
      authenticate
      expect(provider.attempts).to eq([CURRENT_PASSWORD, CURRENT_PASSWORD, PREVIOUS_PASSWORD, CURRENT_PASSWORD])
    end

    scenario('huit processus au renouvellement : un seul échange, aucun échec') do
      started_at = Time.current
      token = authenticate
      Timecop.freeze(started_at + 211.seconds)
      provider.oauth_delay = 0.15
      concurrent_workers { state.rpush('worker_tokens', authenticate) }
      renewed = published_token
      expect(renewed).not_to eq(token)
      expect(state.lrange('worker_tokens', 0, -1)).to all(satisfy { |worker_token| [token, renewed].include?(worker_token) })
      expect(provider.attempts.size).to eq(2)
      expect(lock_value).to be_nil
    end

    scenario('deux instances sans Redis commun : six refus en 91 s, au-delà du seuil Keycloak de cinq') do
      before_derivation
      started_at = Time.current
      provider.refuse_next_logins(100)
      [0, 31, 91].each do |offset|
        Timecop.freeze(started_at + offset.seconds)
        [2, 3].each do |db|
          reconnect_cache(namespace: "instance-#{db}", db:)
          expect_rejection
        end
      end
      expect(provider.attempts.size).to eq(6)
    end

    scenario('cache chiffré et TTL aligné sur expires_in moins dix secondes') do
      token = authenticate
      expect(EncryptedCache.expires_in(INSEE::Authenticate::CACHE_KEY)).to be_between(280, 290)
      values = @cache_redis.keys('*').map { |key| @cache_redis.get(key) }
      expect(values.join).not_to include(token)
      expect(authenticate).to eq(token)
      expect(provider.attempts.size).to eq(1)
    end
  end
end

SIADEINSEESmoke.run do |suite|
  suite.common_scenarios
  suite.siade_scenarios
end
