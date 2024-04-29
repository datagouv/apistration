class DGFIP::LiassesFiscales::ValidateResponse < ValidateResponse
  def call
    if http_not_found?
      make_payload_cacheable!
      fail_with_error!(::DGFIPPotentialNotFoundError.new)
    elsif http_unavailable?
      provider_unavailable!
    elsif dgfip_internal_error?
      provider_internal_error!
    elsif invalid_json? || !http_ok?
      unknown_provider_response!
    elsif no_declarations?
      resource_not_found!(:siren)
    end
  end

  private

  def no_declarations?
    json_body['declarations'].blank?
  end

  def dgfip_internal_error?
    context.response.body.include?("Une erreur applicative s'est produite sur le serveur ADELIE.")
  end
end
