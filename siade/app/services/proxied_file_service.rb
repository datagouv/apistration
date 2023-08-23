require 'securerandom'

class ProxiedFileService
  class ConnectionError < StandardError; end

  def self.set(key)
    new.set(key)
  end

  def self.get(unique_token)
    new.get(unique_token)
  end

  def get(unique_token)
    backend.get(key(unique_token))
  end

  def set(url, expires_in: 24.hours.to_i)
    unique_token = nil

    loop do
      unique_token = SecureRandom.uuid
      break unless backend.exists?(key(unique_token))
    end

    backend.set(key(unique_token), url, ex: expires_in)

    unique_token
  end

  private

  def key(unique_token)
    "#{namespace_key}:#{unique_token}"
  end

  def namespace_key
    'proxied_file'
  end

  def backend
    RedisService.instance
  rescue Redis::BaseConnectionError
    raise ConnectionError
  end
end
