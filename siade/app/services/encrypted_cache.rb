require 'singleton'
require 'lockbox'

class EncryptedCache
  include Singleton

  def self.read(key)
    instance.read(key)
  end

  def self.write(key, value, options = {})
    instance.write(key, value, options)
  end

  def read(key)
    cached_value = cache.read(key)

    return if cached_value.nil?

    unmarshal(decrypt(cached_value))
  rescue TypeError, Lockbox::DecryptionError
    write(key, nil)

    nil
  end

  def write(key, value, options = {})
    if value
      cache.write(
        key,
        encrypt(marshal(value)),
        options
      )
    else
      cache.delete(key)
    end
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

  def cache
    Rails.cache
  end

  def lockbox
    @lockbox ||= Lockbox.new(key: Lockbox.master_key, encode: true)
  end
end
