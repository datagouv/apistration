# :nocov:
if (Rails.env.test? || Rails.env.development?) && ENV['SKIP_MOCKS'].blank?
  Fog.mock!
end

Fog.credentials = Siade.credentials[:fog_credentials]
# :nocov:
