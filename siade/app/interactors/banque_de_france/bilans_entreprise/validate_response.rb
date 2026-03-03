class BanqueDeFrance::BilansEntreprise::ValidateResponse < ValidateResponse
  def call
    internal_server_error! if provider_internal_error?

    unknown_provider_response! if !http_ok? || invalid_json?

    return if json_body['bilans'].present?

    resource_not_found! if not_found?
    internal_server_error! if application_code == 500

    unknown_provider_response!
  end

  private

  def provider_internal_error?
    http_code == 408 || http_internal_error?
  end

  def not_found?
    [
      204,
      400
    ].include?(application_code)
  end

  def application_code
    json_body['code-retour']
  end
end
