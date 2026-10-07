class INSEE::TokenRenewal
  CACHE_KEY = 'insee/token_renewal_window'.freeze
  MARGIN = 90
  RETRY = 30
  OAUTH_EXCHANGE_WORST_CASE = 20

  def self.schedule!(lifetime:, expires_in:)
    return if lifetime <= MARGIN

    write((lifetime - MARGIN).seconds.from_now...expires_in.seconds.from_now)
  end

  def self.due?
    window = read
    return false unless window.present? && window.cover?(Time.current)

    Time.current + (yield * OAUTH_EXCHANGE_WORST_CASE) < window.end
  end

  def self.postpone!
    window = read

    write(RETRY.seconds.from_now...window.end) if window
  end

  def self.read
    Rails.cache.with_local_cache { Rails.cache.read(CACHE_KEY) }
  end

  def self.write(window)
    ttl = window.end - Time.current

    if window.begin < window.end && ttl.positive?
      Rails.cache.write(CACHE_KEY, window, expires_in: ttl)
    else
      Rails.cache.delete(CACHE_KEY)
    end
  end

  private_class_method :read, :write
end
