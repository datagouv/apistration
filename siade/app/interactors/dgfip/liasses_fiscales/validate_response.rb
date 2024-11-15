class DGFIP::LiassesFiscales::ValidateResponse < ValidateResponse
  def call
    if http_unavailable?
      provider_unavailable!
    elsif dgfip_internal_error?
      provider_internal_error!
    elsif http_not_found? || no_declarations?
      resource_not_found!(:siren)
    elsif invalid_json? || !http_ok?
      unknown_provider_response!
    end
  end

  private

  def no_declarations?
    json_body['declarations'].blank?
  rescue JSON::ParserError
    false
  end

  def dgfip_internal_error?
    context.response.body.include?("Une erreur applicative s'est produite sur le serveur ADELIE.")
  end
end
