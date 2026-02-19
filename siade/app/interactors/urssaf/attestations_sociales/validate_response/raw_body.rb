class URSSAF::AttestationsSociales::ValidateResponse::RawBody < ValidateResponse
  def call
    if body.blank?
      internal_server_error!('Le corps de la réponse est vide, il s\'agit d\'une erreur interne du fournisseur')
    elsif provider_server_error?
      build_and_fail!(ProviderInternalServerError)
    elsif json_body_has_errors?
      handle_errors
    end
  rescue TypeError
    handle_json_error_body_not_an_array
  end

  protected

  def handle_errors
    if manual_verification_asked?
      fail_with_error!(ACOSSError.new(:manual_verification_asked))
    elsif ongoing_manual_verification?
      fail_with_error!(ACOSSError.new(:ongoing_manual_verification))
    elsif rate_limited?
      track_rate_limit
      build_and_fail!(ProviderRateLimitingError)
    elsif internal_error?
      build_and_fail!(ProviderInternalServerError)
    elsif not_found?
      build_and_fail!(NotFoundError)
    else
      build_and_fail!(ProviderUnknownError)
    end
  end

  private

  def json_body_has_errors?
    json_errors.any? &&
      !cannot_deliver_document?
  end

  def json_errors
    @json_errors ||= JSON.parse(
      body,
      symbolize_names: true
    )
  rescue JSON::ParserError
    []
  end

  def handle_json_error_body_not_an_array
    error = build_error(ProviderUnknownError, 'Invalid json error payload')
    error.add_to_monitoring_private_context(
      body:
    )
    fail_with_error!(error)
  end

  def build_and_fail!(error_klass)
    fail_with_error!(
      build_error_with_provider_errors(
        error_klass
      )
    )
  end

  def build_error_with_provider_errors(error_klass)
    build_error(error_klass).add_meta(
      provider_errors: json_errors
    )
  end

  def not_found?
    error_code_acoss_for_404.intersect?(errors_codes)
  end

  def internal_error?
    error_code_acoss_for_503.intersect?(errors_codes)
  end

  def provider_server_error?
    body.include?('Une erreur est survenue sur le serveur') && http_not_found?
  end

  def manual_verification_asked?
    %w[FUNC503].intersect?(errors_codes)
  end

  def ongoing_manual_verification?
    %w[FUNC504].intersect?(errors_codes)
  end

  def cannot_deliver_document?
    %w[FUNC502].intersect?(errors_codes)
  end

  def rate_limited?
    %w[FUNC429].intersect?(errors_codes)
  end

  def track_rate_limit
    monitoring_service.track_with_added_context(
      'warning',
      '[URSSAF] Rate limited (FUNC429)',
      { siren: }
    )
  end

  def siren
    context.params[:siren]
  end

  def monitoring_service
    @monitoring_service ||= MonitoringService.instance
  end

  def errors_codes
    @errors_codes ||= json_errors.pluck(:code)
  end

  def error_code_acoss_for_503
    %w[FUNC510 FUNC511 FUNC512 FUNC513 FUNC514 FUNC515 FUNC516]
  end

  def error_code_acoss_for_404
    %w[FUNC501 FUNC517]
  end
end
