# :nocov:
if Rails.env.local? && ENV['SKIP_MOCKS'].blank?
  Fog.mock!
  Fog.credentials = { openstack_auth_url: 'http://localhost' }
else
  Fog.credentials = Siade.credentials[:fog_credentials]
end
# :nocov:
