# :nocov:
if Rails.env.test? || Rails.env.development?
  Fog.mock!
end

Fog.credentials = Siade.credentials[:fog_credentials]
# :nocov:
