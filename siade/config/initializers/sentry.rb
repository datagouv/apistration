Sentry.init do |config|
  config.dsn = Siade.credentials[:sentry_url] unless ENV['DISABLE_SENTRY'] == 'true'

  config.breadcrumbs_logger = [:active_support_logger]
  config.enabled_environments = %w[production staging sandbox]

  config.traces_sample_rate = 1.0

  config.before_send = lambda do |event, _hint|
    begin
      event.request.headers.delete('X-Api-Key')
    rescue NoMethodError
    end

    event
  end
end
