require 'jwt'

class INPI::RNE::Authenticate < AbstractGetToken
  def call
    return try_fallback_or_fail if primary_username_failed_in_cache?

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

  def username_fallback
    params[:inpi_rne_login_username_fallback].presence || Siade.credentials[:inpi_rne_login_username_fallback]
  end

  def password_fallback
    params[:inpi_rne_login_password_fallback] || Siade.credentials[:inpi_rne_login_password_fallback]
  end

  def cache_key
    :"#{super}_#{username}"
  end

  def handle_empty_token(token, response)
    return super unless response.code.to_i == 401

    track_authentication_failure

    unless using_fallback_credentials?
      fallback_token = retry_with_fallback
      return cache_and_return_fallback_token(fallback_token) if fallback_token.present?
    end

    mark_username_as_failed_in_cache!
    fail_to_request_provider!(MaintenanceError)
  end

  def track_authentication_failure
    MonitoringService.instance.track(:error, "INPI RNE authentication failed for username: #{username}")
  end

  def mark_username_as_failed_in_cache!
    Rails.cache.write("inpi_rne_authenticate_failed_#{username}", '1')
  end

  def using_fallback_credentials?
    username == username_fallback
  end

  def retry_with_fallback
    result = self.class.call(
      params: {
        inpi_rne_login_username: username_fallback,
        inpi_rne_login_password: password_fallback
      }
    )

    result.success? ? result.token : nil
  end

  def cache_and_return_fallback_token(fallback_token)
    cache.write(
      fallback_cache_key,
      fallback_token,
      expires_in: token_expires_in(fallback_token)
    )
    fallback_token
  end

  def fallback_cache_key
    :"#{self.class.name.underscore}_#{username_fallback}"
  end

  def token_expires_in(token)
    [JWT.decode(token, nil, false)[0]['exp'] - Time.now.to_i - 10, 0].max
  end

  def cache
    @cache ||= EncryptedCache.instance
  end

  def primary_username_failed_in_cache?
    !using_fallback_credentials? && Rails.cache.exist?("inpi_rne_authenticate_failed_#{username}")
  end

  def try_fallback_or_fail
    if Rails.cache.exist?("inpi_rne_authenticate_failed_#{username_fallback}")
      fail_to_request_provider!(MaintenanceError)
    else
      fallback_token = retry_with_fallback
      if fallback_token.present?
        context.token = fallback_token
      else
        fail_to_request_provider!(MaintenanceError)
      end
    end
  end

  def params
    context.params || {}
  end
end
