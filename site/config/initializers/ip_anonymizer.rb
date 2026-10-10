require Rails.root.join('lib/raw_remote_ip').to_s

Rails.application.config.middleware.insert_after ActionDispatch::RemoteIp, IpAnonymizer::HashIp,
  key: AdminApientreprise.credentials[:ip_anonymizer_key]
Rails.application.config.middleware.insert_before IpAnonymizer::HashIp, RawRemoteIp
