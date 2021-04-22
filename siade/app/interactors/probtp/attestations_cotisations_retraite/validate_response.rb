class PROBTP::AttestationsCotisationsRetraite::ValidateResponse < ValidateResponse
  def call
    if provider_error?
      invalid_provider_response!
    elsif etablissement_not_found?
      resource_not_found!
    else
      ok!
    end
  end

  private

  def provider_error?
    http_error_status? || invalid_json? || custom_error?
  end

  def http_error_status?
    http_code == 500
  end

  def invalid_json?
    json_body

    false
  rescue JSON::ParserError
    true
  end

  def custom_error?
    provider_response_code == '4'
  end

  def entete
    json_body['entete']
  end

  def provider_response_code
    entete['code']
  end

  def etablissement_not_found?
    provider_response_code == '8'
  end
end
