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

  def cache_token(token)
    EncryptedCache.write(INSEE::Authenticate::CACHE_KEY, token, expires_in: 1.hour)
  end

  def invalidate(token)
    INSEE::Authenticate.invalidate_token_cache!(token)
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

    scenario('désynchronisation après un 401 : erreur 01006 propagée, aucun rejeu Sirene') do
      authenticate
      provider.password = 'Unknown-Password1'
      provider.revoke_tokens
      expect { fetch_resource }.to raise_error(ProviderFailure) do |failure|
        expect(failure.context.errors.map(&:code)).to eq(['01006'])
      end
      expect(provider.bearers.size).to eq(1)
      expect(provider.attempts.size).to eq(4)
      expect(guard_active?).to be(true)
    end

    scenario('cache chiffré et TTL aligné sur expires_in moins dix secondes') do
      token = authenticate
      expect(EncryptedCache.expires_in(INSEE::Authenticate::CACHE_KEY)).to be_between(3580, 3590)
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
