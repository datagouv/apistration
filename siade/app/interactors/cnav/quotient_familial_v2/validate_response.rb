class CNAV::QuotientFamilialV2::ValidateResponse < CNAV::ValidateResponse
  raises ProviderUnprocessableEntityError, reason: :rejected_period

  PERIOD_TOO_OLD_ERROR_CODE = 40_029
  PERIOD_TOO_OLD_MESSAGE = 'La période demandée est antérieure de plus de 23 mois.'.freeze

  protected

  def bad_request_error!
    return super unless error_code_from_body.to_i == PERIOD_TOO_OLD_ERROR_CODE

    track_bad_request!

    rejected_period!
  end

  private

  def rejected_period!
    unprocessable_entity!(:rejected_period, PERIOD_TOO_OLD_MESSAGE, meta: provider_error_meta)
  end
end
