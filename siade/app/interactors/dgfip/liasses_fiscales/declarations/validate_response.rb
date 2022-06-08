class DGFIP::LiassesFiscales::Declarations::ValidateResponse < ValidateResponse
  def call
    if http_not_found?
      make_payload_cacheable!
      fail_with_error!(::DGFIPPotentialNotFoundError.new)
    elsif invalid_json? || !http_ok?
      unknown_provider_response!
    end
  end
end
