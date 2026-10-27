class CNAV::QuotientFamilialV2::ValidateResponse < CNAV::ValidateResponse
  raises ProviderUnprocessableEntityError, reason: :rejected_period
  raises MSAError, kind: :qf_calculation_impossible

  PERIOD_TOO_OLD_ERROR_CODE = 40_029
  PERIOD_TOO_OLD_MESSAGE = 'La période demandée est antérieure de plus de 23 mois.'.freeze

  QF_CALCULATION_IMPOSSIBLE_ERROR_CODE = 40_000

  protected

  def bad_request_error!
    return qf_calculation_impossible_by_msa! if qf_calculation_impossible_by_msa?
    return super unless error_code_from_body.to_i == PERIOD_TOO_OLD_ERROR_CODE

    track_bad_request!

    rejected_period!
  end

  private

  def rejected_period!
    unprocessable_entity!(:rejected_period, PERIOD_TOO_OLD_MESSAGE, meta: provider_error_meta)
  end

  def qf_calculation_impossible_by_msa?
    error_code_from_body.to_i == QF_CALCULATION_IMPOSSIBLE_ERROR_CODE && regime == 'MSA'
  end

  def qf_calculation_impossible_by_msa!
    track_bad_request!

    fail_with_error!(MSAError.new(:qf_calculation_impossible, provider_error_meta))
  end

  def bad_request_tracking_level
    return 'info' if qf_calculation_impossible_by_msa?

    super
  end
end
