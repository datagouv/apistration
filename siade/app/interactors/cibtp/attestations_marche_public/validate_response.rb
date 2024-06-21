class CIBTP::AttestationsMarchePublic::ValidateResponse < ValidateResponse
  def call
    return if http_ok?

    resource_not_found! if http_not_found? || http_unprocessable_entity?

    provider_internal_error! if http_internal_error? || http_conflict?

    unknown_provider_response!
  end
end
