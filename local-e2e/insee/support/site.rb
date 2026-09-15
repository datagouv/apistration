require_relative 'support'
require 'faraday'
require 'faraday/retry'
require 'active_job'
require 'good_job'

ActiveJob::Base.queue_adapter = :test
ActiveJob::Base.logger = Logger.new(File::NULL)

class SiteINSEESmoke < INSEESmoke
  def application_name
    'site'
  end

  def source_directories
    %w[clients services jobs]
  end

  def authenticate
    INSEEAPIAuthentication.new.access_token
  end

  def published_token
    INSEEAPIAuthentication.published_token
  end

  def authentication_outcome
    authenticate
    'granted'
  rescue INSEEAPIAuthentication::AuthenticationError
    'rejected'
  rescue INSEEAPIAuthentication::TemporaryError
    'temporary'
  end

  def cache_token(token)
    Rails.cache.write(INSEEAPIAuthentication::TOKEN_CACHE_KEY, token, namespace: 'insee', expires_in: 1.hour)
  end

  def invalidate(token)
    INSEEAPIAuthentication.invalidate_token_cache!(token)
  end

  def clear_guards
    INSEEAPIAuthentication.clear_guards!
  end

  def lock_value
    Rails.cache.read(INSEEAPIAuthentication::LOCK_CACHE_KEY, namespace: 'insee')
  end

  def write_lock(owner)
    Rails.cache.write(INSEEAPIAuthentication::LOCK_CACHE_KEY, owner, namespace: 'insee', expires_in: 30)
  end

  def expect_rejection
    expect { authenticate }.to raise_error(INSEEAPIAuthentication::AuthenticationError)
  end

  def expect_temporary_failure
    expect { authenticate }.to raise_error(INSEEAPIAuthentication::TemporaryError)
  end

  def fetch_resource
    INSEESireneAPIClient.new.etablissement(siret: '12345678900001').fetch('etablissement')
  end

  def rotate
    INSEE::PasswordRotation.new.rotate!
  end

  def perform_job
    INSEEPasswordRotationJob.perform_now
  end

  def site_scenarios
    scenario('rotation complète : précédent → courant, ancien token refusé puis client rétabli') do
      provider.password = PREVIOUS_PASSWORD
      expect(fetch_resource).to include('siret' => '12345678900001')
      expect(rotate).to eq(:renewed)
      expect(provider.password).to eq(CURRENT_PASSWORD)
      expect(provider.renewals).to eq(1)
      expect(fetch_resource).to include('siret' => '12345678900001')
      expect(provider.bearers.size).to eq(3)
      expect(rotate).to eq(:already_current)
      expect(provider.renewals).to eq(1)
    end

    scenario('première rotation de novembre : statique → premier mot de passe dérivé') do
      Timecop.freeze(Time.new(2026, 11, 1, 0, 5, 0, '+01:00'))
      provider.password = STATIC_PASSWORD
      expect(rotate).to eq(:renewed)
      expect(provider.password).to eq(PREVIOUS_PASSWORD)
      expect(provider.attempts).to eq([PREVIOUS_PASSWORD, STATIC_PASSWORD])
    end

    scenario('sortie du bypass : renouvellement, rejeu idempotent puis retrait du credential') do
      use_bypass
      provider.password = BYPASS_PASSWORD
      expect(INSEE::PasswordRotation.new.exit_bypass!).to eq(:renewed)
      expect(INSEE::PasswordRotation.new.exit_bypass!).to eq(:already_current)
      credentials.delete(INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY)
      expect(fetch_resource).to include('siret' => '12345678900001')
      expect(provider.password).to eq(CURRENT_PASSWORD)
      expect(provider.renewals).to eq(1)
    end

    scenario('sortie du bypass avant novembre : aucun appel fournisseur') do
      use_bypass
      Timecop.freeze(Time.new(2026, 10, 31, 12, 0, 0, '+01:00'))
      expect { INSEE::PasswordRotation.new.exit_bypass! }.to raise_error(INSEE::PasswordRotation::DerivationNotStartedError)
      expect(provider.attempts).to be_empty
      expect(provider.renewals).to eq(0)
    end

    scenario('réponse de renouvellement perdue : le rejeu constate déjà le mot de passe courant') do
      use_bypass
      provider.password = BYPASS_PASSWORD
      provider.renewal_fault = :timeout_after_rotation
      expect { INSEE::PasswordRotation.new.exit_bypass! }.to raise_error(INSEE::PasswordRotation::UnavailableError)
      expect(provider.password).to eq(CURRENT_PASSWORD)
      expect(INSEE::PasswordRotation.new.exit_bypass!).to eq(:already_current)
      expect(provider.renewals).to eq(1)
    end

    scenario('rotation désynchronisée : deux essais, alerte et garde-fou') do
      provider.password = 'Unknown-Password1'
      expect(rotate).to eq(:desynchronized)
      expect(provider.attempts).to eq([CURRENT_PASSWORD, PREVIOUS_PASSWORD])
      expect(provider.renewals).to eq(0)
      expect(guard_active?).to be(true)
      expect(alerts.size).to eq(1)
    end

    [503, :timeout].each do |fault|
      scenario("renouvellement #{fault} : erreur explicite puis reprise réussie") do
        provider.password = PREVIOUS_PASSWORD
        provider.renewal_fault = fault
        expect { rotate }.to raise_error(INSEE::PasswordRotation::UnavailableError)
        expect(provider.password).to eq(PREVIOUS_PASSWORD)
        expect(guard_active?).to be(false)
        provider.renewal_fault = nil
        expect(rotate).to eq(:renewed)
        expect(provider.password).to eq(CURRENT_PASSWORD)
      end
    end

    scenario('job : inactif en développement, actif sur la frontale de production') do
      provider.password = PREVIOUS_PASSWORD
      Rails.env = 'development'
      ENV['FRONTAL'] = 'true'
      perform_job
      expect(provider.attempts).to be_empty
      Rails.env = 'production'
      ENV['FRONTAL'] = 'false'
      perform_job
      expect(provider.attempts).to be_empty
      ENV['FRONTAL'] = 'true'
      perform_job
      expect(provider.password).to eq(CURRENT_PASSWORD)
      expect(provider.renewals).to eq(1)
      expect(alerts.last).to eq([['INSEE password rotated'], { level: :info, context: {} }])
    end

    scenario('job : aucun essai avec un bypass, avant novembre ou sous garde-fou') do
      Rails.env = 'production'
      ENV['FRONTAL'] = 'true'
      use_bypass
      perform_job
      credentials.delete(INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY)
      Timecop.freeze(Time.new(2026, 10, 31, 12, 0, 0, '+01:00'))
      perform_job
      Timecop.freeze(Time.new(2027, 1, 15, 12, 0, 0, '+01:00'))
      INSEEAPIAuthentication.new.record_authentication_failure!('smoke guard')
      perform_job
      expect(provider.attempts).to be_empty
      expect(provider.renewals).to eq(0)
    end

    scenario('job : avertissement sur indisponibilité puis reprise au lancement suivant') do
      Rails.env = 'production'
      ENV['FRONTAL'] = 'true'
      provider.password = PREVIOUS_PASSWORD
      provider.oauth_fault = 503
      perform_job
      expect(alerts.last.last).to include(level: :warning)
      expect(guard_active?).to be(false)
      provider.oauth_fault = nil
      perform_job
      expect(provider.password).to eq(CURRENT_PASSWORD)
    end
  end
end

SiteINSEESmoke.run do |suite|
  suite.common_scenarios
  suite.site_scenarios
end
