class SIADE::V2::Responses::AttestationsSocialesACOSS < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'ACOSS'
  end

  def adapt_raw_response_code
    if has_errors?
      set_errors_messages
      get_http_code
    else
      200
    end
  rescue TypeError
    handle_json_error_body_not_an_array
  end

  private

  def has_errors?
    empty_body? || json_body_has_errors?
  end

  def set_errors_messages
    empty_body? ? set_error_for_empty_body : set_standard_errors
  end

  def get_http_code
    if contains_code_for_503?
      502
    elsif contains_code_for_404?
      404
    else
      502
    end
  end

  def empty_body?
    @raw_response.body.blank?
  end

  def json_body_has_errors?
    json_errors.any?
  end

  def json_errors
    # body is an encoded64 PDF if OK
    # else it's a JSON list with errors infos
    @json_errors ||= JSON.parse(
      @raw_response.body,
      symbolize_names: true
    )
  rescue StandardError
    []
  end

  def contains_code_for_404?
    (error_code_acoss_for_404 & errors_codes).any?
  end

  def contains_code_for_503?
    (error_code_acoss_for_503 & errors_codes).any?
  end

  def errors_codes
    @errors_codes ||= json_errors.pluck(:code)
  end

  def set_standard_errors
    error_codes_acoss_concatenate = ''
    error_messages_acoss = []
    error_descriptions_acoss = []

    json_errors.each do |error|
      @error_code_acoss = error[:code]
      @error_message_acoss = error[:message]
      @error_description_acoss = error[:description]

      set_standard_error_message

      error_codes_acoss_concatenate += "#{error[:code]} "
      error_messages_acoss          << @error_message_acoss
      error_descriptions_acoss      << @error_description_acoss
    end

    error_codes_acoss_concatenate.strip!

    add_context_to_provider_error_tracking(
      acoss_error: error_codes_acoss_concatenate,
      acoss_messages: error_messages_acoss,
      accos_description: error_descriptions_acoss
    )

    @provider_error_custom_code = error_codes_acoss_concatenate
  end

  def set_error_for_empty_body
    @error_code_acoss = 'NO CODE EMPTY BODY'
    @error_message_acoss = 'Empty body'
    @error_description_acoss = 'ACOSS request failed due to empty body'

    set_error_message_for(502)

    add_context_to_provider_error_tracking(
      acoss_error: @error_code_acoss,
      acoss_message: @error_message_acoss,
      accos_description: @error_description_acoss
    )

    @provider_error_custom_code = @error_code_acoss
  end

  def handle_json_error_body_not_an_array
    unless internal_error_message?
      Sentry.set_extras(
        body: json_errors
      )
      Sentry.capture_message(
        'Wrong payload from ACOSS (originaly reported in 1895733)'
      )
    end

    (@errors ||= []) << ProviderUnknownError.new(
      provider_name,
      "L'ACOSS a répondu avec une erreur non supportée (erreur: ACOSS request failed due to unexpected body)"
    )

    502
  end

  def internal_error_message?
    json_errors[:detail].try(:[], :msgId).present?
  rescue JSON::ParseError
    false
  end

  def set_error_message
    if error_code_acoss_for_503.include?(@error_code_acoss)
      set_error_message_for(503)
    elsif error_code_acoss_for_404.include?(@error_code_acoss)
      set_error_message_for(404)
    else
      set_error_message_for(502)
    end
  end

  def error_code_acoss_for_503
    %w[FUNC502 FUNC503 FUNC504 FUNC510 FUNC511 FUNC512 FUNC513 FUNC514 FUNC515 FUNC516 FUNC429]
  end

  def error_code_acoss_for_404
    %w[FUNC501 FUNC517]
  end

  def set_standard_error_message
    if error_code_acoss_for_503.include?(@error_code_acoss)
      set_error_message_for(503)
    elsif error_code_acoss_for_404.include?(@error_code_acoss)
      set_error_message_for(404)
    else
      set_error_message_for(502)
    end
  end

  def set_error_message_404
    (@errors ||= []) << NotFoundError.new(
      provider_name,
      "Siren invalide, l'ACOSS ne peut délivrer d'attestation (erreur: #{@error_description_acoss} Code d'erreur ACOSS : #{@error_code_acoss})"
    )
  end

  def set_error_message_503
    (@errors ||= []) << ProviderTimeoutError.new(
      provider_name,
      "L'ACOSS ne peut répondre à votre requête, réessayez ultérieurement (erreur: #{@error_description_acoss})"
    )
  end

  def set_error_message_502
    (@errors ||= []) << ProviderUnknownError.new(
      provider_name,
      "L'ACOSS a répondu avec une erreur non supportée (erreur: #{@error_description_acoss})"
    )
  end
end
