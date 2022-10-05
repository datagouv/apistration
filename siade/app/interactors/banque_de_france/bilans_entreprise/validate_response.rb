class BanqueDeFrance::BilansEntreprise::ValidateResponse < ValidateResponse
  include BanqueDeFrance::BilansEntreprise::BodyDecoder

  def call
    unknown_provider_response! if !http_ok? || invalid_json?

    return if json_body['bilans'].present?

    resource_not_found! if not_found?
    invalid_provider_response! if application_code == 500

    unknown_provider_response!
  rescue Zlib::GzipFile::Error
    invalid_provider_response!('Chiffrage du corps de la réponse invalide')
  end

  private

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
