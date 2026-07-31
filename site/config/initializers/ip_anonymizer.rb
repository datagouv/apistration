Rails.application.config.middleware.insert_after ActionDispatch::RemoteIp, IpAnonymizer::HashIp,
  key: AdminApientreprise.credentials[:ip_anonymizer_key]
