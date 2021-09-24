class PROBTP::AttestationsCotisationsRetraite::ValidateResponse < ValidateResponse
  def call
    if internal_error? || invalid_json?
      invalid_provider_response!
    elsif custom_error?
      invalid_provider_response!("Erreur fournisseur: #{entete['message']}")
    elsif etablissement_not_found?
      resource_not_found!
    end
  end

  protected

  def not_found_message(_resource)
    "Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel."
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
