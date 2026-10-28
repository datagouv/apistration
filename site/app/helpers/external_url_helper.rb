module ExternalUrlHelper
  def datapass_authorization_request_url(authorization_request)
    "#{datapass_base_url}/api-#{authorization_request.api}/#{authorization_request.external_id}"
  end

  def datapass_base_url
    case Rails.env
    when 'staging'
      'https://staging.datapass.api.gouv.fr'
    when 'sandbox', 'test', 'development'
      'https://sandbox.datapass.api.gouv.fr'
    else
      'https://datapass.api.gouv.fr'
    end
  end

  def datapass_v2_public_authorization_request_url(authorization_request)
    "#{datapass_v2_base_url(authorization_request.api)}/public/demandes/#{authorization_request.public_id}"
  end

  def datapass_v2_base_url(api)
    case Rails.env
    when 'staging'
      "https://staging.api-#{api}.v2.datapass.api.gouv.fr"
    when 'sandbox'
      "https://sandbox.api-#{api}.v2.datapass.api.gouv.fr"
    else
      "https://api-#{api}.v2.datapass.api.gouv.fr"
    end
  end
end
