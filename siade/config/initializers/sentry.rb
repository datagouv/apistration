Sentry.init do |config|
  config.dsn = Siade.credentials[:sentry_url] unless ENV['DISABLE_SENTRY'] == 'true'

  config.breadcrumbs_logger = [:active_support_logger]
  config.rails.structured_logging.enabled = false
  config.enabled_environments = %w[production staging sandbox]

  config.traces_sampler = lambda do |sampling_context|
    path = sampling_context.dig(:env, 'PATH_INFO').to_s
    next 0.0 if Siade::Application::HEALTH_CHECK_PATH.match?(path)

    sampling_context[:parent_sampled].nil? ? 1.0 : sampling_context[:parent_sampled]
  end

  config.before_send = lambda do |event, _hint|
    event_kind = event.fingerprint.presence&.join(':') ||
                 event.exception&.values&.first&.type ||
                 event.message
    cache_key = "sentry:#{event_kind}"

    if Rails.cache.increment(cache_key, 1, expires_in: 1.hour).to_i > 5_000
      next nil
    end

    begin
      event.request.headers.delete('X-Api-Key')
    rescue NoMethodError
    end

    SentryEventPayloadEchoFilter.call(event)
    SentryEventUtf8Normalizer.call(event)

    event
  end
end
