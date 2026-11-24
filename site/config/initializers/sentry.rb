return unless ENV['FRONTAL'] == 'true'

Sentry.init do |config|
  config.dsn = AdminApientreprise.credentials[:sentry_dsn]

  config.breadcrumbs_logger = [:active_support_logger]
  config.rails.structured_logging.enabled = false
  config.enabled_environments = %w[production staging]

  config.traces_sampler = lambda do |sampling_context|
    path = sampling_context.dig(:env, 'PATH_INFO').to_s
    next 0.0 if AdminApientreprise::Application::HEALTH_CHECK_PATH.match?(path)

    sampling_context[:parent_sampled].nil? ? 1.0 : sampling_context[:parent_sampled]
  end

  config.excluded_exceptions += ['ActionView::MissingTemplate']
end
