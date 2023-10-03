class CarifOref::CertificationsQualiopiFranceCompetences::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    unknown_provider_response! if http_code != 200 || invalid_json?
    resource_not_found! if json_body['siret_actif'].nil?
  end
end
