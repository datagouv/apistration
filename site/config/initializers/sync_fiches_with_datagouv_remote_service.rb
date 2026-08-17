Rails.application.config.after_initialize do
  Thread.new { Datagouv::SyncFichesRemoteService.new.perform } if Rails.env.production?
end
