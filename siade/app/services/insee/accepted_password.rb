require 'openssl'

class INSEE::AcceptedPassword
  CACHE_NAMESPACE = 'insee'.freeze
  CACHE_KEY = 'last_accepted_password'.freeze
  TTL = 1.day

  def self.remember!(password)
    Rails.cache.write(CACHE_KEY, fingerprint(password), namespace: CACHE_NAMESPACE, expires_in: TTL)
  end

  def self.last?(password)
    Rails.cache.with_local_cache { Rails.cache.read(CACHE_KEY, namespace: CACHE_NAMESPACE) } == fingerprint(password)
  end

  def self.forget!
    Rails.cache.delete(CACHE_KEY, namespace: CACHE_NAMESPACE)
  end

  def self.fingerprint(password)
    OpenSSL::Digest::SHA256.hexdigest(password.to_s)
  end

  private_class_method :fingerprint
end
