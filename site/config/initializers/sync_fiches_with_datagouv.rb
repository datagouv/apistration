Rails.application.config.after_initialize do
  Datagouv::SyncFichesJob.enqueue_at_boot
end
