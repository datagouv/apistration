class CNAF::QuotientFamilialV2 < RetrieverOrganizer
  REGIME_CODE_MSA = '00171001'.freeze
  REGIME_CODE_CNAF = '00810011'.freeze

  REGIME_CODE_LABEL = {
    REGIME_CODE_MSA => 'MSA',
    REGIME_CODE_CNAF => 'CNAF'
  }.freeze

  organize CNAF::ValidateParams,
    CNAF::QuotientFamilialV2::Authenticate,
    CNAF::QuotientFamilialV2::MakeRequest,
    CNAF::QuotientFamilialV2::ValidateResponse,
    CNAF::QuotientFamilialV2::BuildResource

  def provider_name
    'CNAF'
  end

  def rollback
    super

    track_not_found_errors
  end

  private

  def track_not_found_errors
    not_found_errors.each do |not_found_error|
      monitoring_service.track(
        'warning',
        "[#{provider_name}] Error: #{not_found_error.detail}"
      )
    end
  end

  def not_found_errors
    context.errors.select do |error|
      error.kind == :not_found
    end
  end
end
