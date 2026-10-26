module Simplifions
  module RemoteCache
    def reset!
      Rails.cache.delete(self.class::CACHE_KEY)
    end

    private

    def cached(&)
      Rails.cache.fetch(self.class::CACHE_KEY, expires_in: cache_ttl, &)
    end

    def cache_ttl
      ENV.fetch('SIMPLIFIONS_CACHE_TTL_MINUTES', '15').to_i.minutes
    end
  end
end
