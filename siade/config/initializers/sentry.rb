Sentry.init do |config|
  config.dsn = Siade.credentials[:sentry_url]

  config.breadcrumbs_logger = [:active_support_logger]
  config.enabled_environments = %w[production staging]

  config.traces_sample_rate = 1.0
end
