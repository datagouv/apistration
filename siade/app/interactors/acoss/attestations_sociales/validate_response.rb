class ACOSS::AttestationsSociales::ValidateResponse < ValidateResponse
  def call
    if body.blank?
      internal_server_error!('Blank body')
    elsif json_body_has_errors?
      handle_errors
    end
  rescue TypeError
    handle_json_error_body_not_an_array
  end

  private

  def handle_errors
    if manual_verification_asked?
      fail_with_error!(ACOSSError.new(:manual_verification_asked))
    elsif ongoing_manual_verification?
      fail_with_error!(ACOSSError.new(:ongoing_manual_verification))
    elsif cannot_deliver_document?
      fail_with_error!(ACOSSError.new(:cannot_deliver_document))
    elsif internal_error?
      build_and_fail!(ProviderInternalServerError)
    elsif not_found?
      build_and_fail!(NotFoundError)
    else
      build_and_fail!(ProviderUnknownError)
    end
  end

  def json_body_has_errors?
    json_errors.any?
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
    (error_code_acoss_for_404 & errors_codes).any?
  end

  def internal_error?
    (error_code_acoss_for_503 & errors_codes).any?
  end

  def manual_verification_asked?
    (%w[FUNC503] & errors_codes).any?
  end

  def ongoing_manual_verification?
    (%w[FUNC504] & errors_codes).any?
  end

  def cannot_deliver_document?
    (%w[FUNC502] & errors_codes).any?
  end

  def errors_codes
    @errors_codes ||= json_errors.pluck(:code)
  end

  def error_code_acoss_for_503
    %w[FUNC510 FUNC511 FUNC512 FUNC513 FUNC514 FUNC515 FUNC516 FUNC429]
  end

  def error_code_acoss_for_404
    %w[FUNC501 FUNC517]
  end
end
