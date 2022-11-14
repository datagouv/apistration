class DGFIP::LiassesFiscales::ValidateResponse < ValidateResponse
  def call
    if http_not_found?
      make_payload_cacheable!
      fail_with_error!(::DGFIPPotentialNotFoundError.new)
    elsif http_unavailable?
      provider_unavailable!
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
end
