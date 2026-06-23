module Simplifions
  module RemoteCache
    USER_AGENT = 'APIEntreprise-site/1.0'.freeze

    def reset!
      Rails.cache.delete(self.class::CACHE_KEY)
      @process_cache = nil
      @faraday_connection = nil
    end

    private

    def cached(&block)
      if Rails.cache.instance_of?(ActiveSupport::Cache::NullStore)
        @process_cache ||= block.call
      else
        Rails.cache.fetch(self.class::CACHE_KEY, expires_in: cache_ttl, &block)
      end
    end

    def faraday_connection
      @faraday_connection ||= Faraday.new(headers: { 'User-Agent' => USER_AGENT }) do |f|
        f.request :retry, max: 1, interval: 1
        f.response :raise_error
        f.adapter :net_http
        f.options.open_timeout = 2
        f.options.timeout = 5
      end
    end

    def cache_ttl
      ENV.fetch('SIMPLIFIONS_CACHE_TTL_MINUTES', '15').to_i.minutes
    end
  end
end
