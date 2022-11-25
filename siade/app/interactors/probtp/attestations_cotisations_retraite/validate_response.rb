class PROBTP::AttestationsCotisationsRetraite::ValidateResponse < ValidateResponse
  def call
    if internal_error?
      internal_server_error!
    elsif invalid_json?
      unknown_provider_response!
    elsif custom_error?
      internal_server_error!("Erreur fournisseur: #{entete['message']}")
    elsif etablissement_not_found?
      resource_not_found!(:siret_or_siren)
    end

    unknown_provider_response! unless http_ok?
  end

  private

  def internal_error?
    http_code == 500
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
