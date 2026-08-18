Rails.application.config.after_initialize do
  Datagouv::SyncFichesJob.perform_later if Rails.env.production?
end
