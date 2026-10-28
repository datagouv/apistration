Rails.application.config.after_initialize do
  next unless Rails.env.production? && ENV['FRONTAL'] == 'true' && GoodJob::CLI.within_exe?

  HyperpingMonitorsSyncJob.perform_later
end
