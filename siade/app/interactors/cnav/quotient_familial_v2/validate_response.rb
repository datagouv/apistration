class CNAV::QuotientFamilialV2::ValidateResponse < CNAV::ValidateResponse
  raises ProviderUnprocessableEntityError, reason: :rejected_period

  PERIOD_TOO_OLD_ERROR_CODE = 40_029
  PERIOD_TOO_OLD_MESSAGE = 'La période demandée est antérieure de plus de 24 mois.'.freeze

  FAMILY_PROVIDER_FAILURE_ERROR_CODES = [40_000, 40_024].freeze

  protected

  def bad_request_error!
    track_bad_request!

    return rejected_period! if error_code_from_body.to_i == PERIOD_TOO_OLD_ERROR_CODE
    return family_provider_failure! if FAMILY_PROVIDER_FAILURE_ERROR_CODES.include?(error_code_from_body.to_i)

    rejected_civility!
  end

  private

  def family_provider_failure!
    fail_with_error!(build_error(::ProviderInternalServerError).add_meta(provider_error_meta))
  end

  def rejected_period!
    unprocessable_entity!(:rejected_period, PERIOD_TOO_OLD_MESSAGE, meta: provider_error_meta)
  end
end
