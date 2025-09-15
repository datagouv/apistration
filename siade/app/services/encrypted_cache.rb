require 'singleton'
require 'lockbox'
require 'digest/sha2'

class EncryptedCache
  include Singleton

  def self.read(key)
    instance.read(key)
  end

  def self.write(key, value, options = {})
    instance.write(key, value, options)
  end

  def self.expires_in(key)
    instance.expires_in(key)
  end

  def read(key)
    cached_value = cache.read(hashed_key(key))

    return if cached_value.nil?

    unmarshal(decrypt(cached_value))
  rescue TypeError, Lockbox::DecryptionError, NoMethodError
    write(key, nil)

    nil
  end

  def expires_in(key)
    @ttl = nil

    cache.redis.with do |r|
      namespace = Rails.cache.options[:namespace]
      hashed_key = namespace ? "#{namespace}:#{hashed_key(key)}" : hashed_key(key)

      @ttl = r.ttl(hashed_key)
    end

    return if @ttl.negative?

    @ttl
  end

  def write(key, value, options = {})
    if value
      cache.write(
        hashed_key(key),
        encrypt(marshal(value)),
        options
      )
    else
      cache.delete(hashed_key(key))
    end
  rescue Redis::CommandError => e
    track_redis_error(e, key, options)
  end

  private

  def encrypt(value)
    lockbox.encrypt(value)
  end

  def decrypt(value)
    lockbox.decrypt(value)
  end

  def marshal(value)
    Marshal.dump(value)
  end

  # rubocop:disable Security/MarshalLoad
  def unmarshal(value)
    Marshal.load(value)
  end
  # rubocop:enable Security/MarshalLoad

  def track_redis_error(redis_error, key, options)
    MonitoringService.instance.track_with_added_context(
      :warn,
      'EncryptedCache redis error',
      {
        exception_message: redis_error.message,
        params: {
          key:,
          options:
        }
      }
    )
  end

  def hashed_key(key)
    Digest::SHA256.hexdigest("#{salt_key}:#{key}")
  end

  def salt_key
    Siade.credentials[:encrypted_cache_salt_key]
  end

  def cache
    Rails.cache
  end

  def lockbox
    @lockbox ||= Lockbox.new(key: Lockbox.master_key, encode: true)
  end
end
