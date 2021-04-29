class ACOSS::AttestationsSociales::ValidateResponse < ValidateResponse
  def call
    if body.blank?
      invalid_provider_response!('Blank body')
    elsif json_body_has_errors?
      handle_errors
    end
  rescue TypeError
    invalid_provider_response!('Invalid json error payload')
  end

  private

  def handle_errors
    if internal_error?
      invalid_provider_response!
    elsif not_found?
      resource_not_found!
    else
      unknown_provider_response!
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

  def not_found?
    (error_code_acoss_for_404 & errors_codes).any?
  end

  def internal_error?
    (error_code_acoss_for_503 & errors_codes).any?
  end

  def errors_codes
    @errors_codes ||= json_errors.pluck(:code)
  end

  def error_code_acoss_for_503
    %w[FUNC502 FUNC503 FUNC504 FUNC510 FUNC511 FUNC512 FUNC513 FUNC514 FUNC515 FUNC516 FUNC429]
  end

  def error_code_acoss_for_404
    %w[FUNC501 FUNC517]
  end
end
