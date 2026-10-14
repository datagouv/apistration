class ScopeCatalog
  CACHE_TTL = ENV.fetch('DATAPASS_SCOPE_CATALOG_CACHE_TTL_MINUTES', '360').to_i.minutes

  def self.for(api)
    new(api)
  end

  def initialize(api)
    @api = api
  end

  def lookup(scope_value)
    scopes[scope_value]
  end

  private

  attr_reader :api

  def scopes
    Rails.cache.fetch(cache_key, expires_in: CACHE_TTL) do
      fetch_scopes.tap { |data| Rails.cache.write(stale_cache_key, data, expires_in: nil) }
    end
  rescue Faraday::Error, TypeError, NoMethodError => e
    Sentry.capture_exception(e)
    Rails.cache.read(stale_cache_key) || {}
  end

  def fetch_scopes
    DataPassAPIClient.new.definitions(api)['scopes'].to_h do |scope|
      [scope['value'], { provider: scope['provider'], group: scope['group'], name: scope['name'] }]
    end
  end

  def cache_key
    "data_pass_scope_catalog/#{api}"
  end

  def stale_cache_key
    "#{cache_key}/stale"
  end
end
