Rails.application.config.after_initialize do
  Thread.new { SyncPingsWithMonitorsRemoteService.new.perform } if Rails.env.production?
end
