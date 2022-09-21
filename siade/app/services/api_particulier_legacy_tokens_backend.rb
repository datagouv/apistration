require 'singleton'
require 'digest'

class APIParticulierLegacyTokensBackend
  include Singleton

  def self.exists?(key)
    instance.exists?(key)
  end

  def self.get(key)
    instance.get(key)
  end

  def exists?(key)
    backend.key?(key) ||
      backend.key?(hashed_key(key))
  end

  def get(key)
    backend[key] || backend[hashed_key(key)] || {}
  end

  private

  def backend
    @backend ||= load_backend
  end

  def hashed_key(key)
    Digest::SHA512.hexdigest(key)
  end

  def load_backend
    YAML.load_file(
      Rails.root.join('config/api_particulier_legacy_tokens.yml')
    )
  end
end
