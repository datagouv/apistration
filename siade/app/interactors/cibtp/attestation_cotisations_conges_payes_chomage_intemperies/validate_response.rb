class CIBTP::AttestationCotisationsCongesPayesChomageIntemperies::ValidateResponse < ValidateResponse
  def call
    return if http_ok?

    resource_not_found! if http_not_found?

    missing_payments_error! if http_unprocessable_entity?

    provider_internal_error! if http_internal_error? || http_conflict?

    unknown_provider_response!
  end

  private

  def missing_payments_error!
    context.errors << CIBTPMissingPaymentsError.new
    context.fail!
  end
end
