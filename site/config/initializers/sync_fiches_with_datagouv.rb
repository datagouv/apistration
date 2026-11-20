Rails.application.config.after_initialize do
  next unless (Rails.env.production? || Rails.env.sandbox?) && GoodJob::CLI.within_exe?

  Datagouv::SyncFichesJob.perform_later
end
