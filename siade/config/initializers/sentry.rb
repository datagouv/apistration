Sentry.init do |config|
  config.dsn = Siade.credentials[:sentry_url] unless ENV['DISABLE_SENTRY'] == 'true'

  config.breadcrumbs_logger = [:active_support_logger]
  config.enabled_environments = %w[production staging sandbox]

  config.traces_sample_rate = 1.0

  config.before_send = lambda do |event, _hint|
    cache_key = "sentry:#{event.fingerprint&.join(':') || event.exception&.values&.first&.type}"

    if Rails.cache.increment(cache_key, 1, expires_in: 1.hour) > 5_000
      next nil
    end

    begin
      event.request.headers.delete('X-Api-Key')
    rescue NoMethodError
    end

    event
  end
end
