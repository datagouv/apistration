require 'jwt'

class INPI::RNE::Authenticate < AbstractGetToken
  def call
    fail_to_request_provider!(MaintenanceError) if Rails.cache.exist?("inpi_rne_authenticate_failed_#{username}")

    super
  end

  protected

  def request_params
    {
      username:,
      password:
    }
  end

  def client_url
    Siade.credentials[:inpi_rne_login_url]
  end

  def access_token(response)
    JSON.parse(response.body)['token']
  end

  def expires_in(response)
    token = access_token(response)

    JWT.decode(token, nil, false)[0]['exp'] - Time.now.to_i
  end

  def username
    params[:inpi_rne_login_username].presence || Siade.credentials[:inpi_rne_login_username]
  end

  def password
    params[:inpi_rne_login_password].presence || Siade.credentials[:inpi_rne_login_password]
  end

  def cache_key
    :"#{super}_#{username}"
  end

  def handle_empty_token(token, response)
    if response.code.to_i == 401
      track_authentication_failure
      mark_username_as_failed_in_cache!

      fail_to_request_provider!(MaintenanceError)
    else
      super
    end
  end

  def track_authentication_failure
    MonitoringService.instance.track(:error, "INPI RNE authentication failed for username: #{username}")
  end

  def mark_username_as_failed_in_cache!
    Rails.cache.write("inpi_rne_authenticate_failed_#{username}", '1')
  end

  def params
    context.params || {}
  end
end
