Rails.application.config.after_initialize do
  SyncPingsWithMonitorsRemoteService.new.perform if Rails.env.production?
end
