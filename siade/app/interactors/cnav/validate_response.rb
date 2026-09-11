class CNAV::ValidateResponse < ValidateResponse
  SNGI_UNIDENTIFIED_MESSAGE = "Les paramètres fournis ne permettent pas d'identifier un allocataire.".freeze

  raises ProviderUnprocessableEntityError, reason: :unidentified_person
  raises ProviderUnprocessableEntityError, reason: :rejected_civility

  ALLOCATAIRE_NOT_REFERENCED = raises ::NotFoundError,
    provider: 'CNAF & MSA',
    title: 'Allocataire non référencé',
    detail: "L'allocataire n'est pas référencé auprès des caisses éligibles"

  FILE_NOT_FOUND_PER_REGIME = {
    'CNAF' => raises(::NotFoundError, provider: 'CNAF', title: 'Dossier allocataire absent CNAF', detail: "Le dossier allocataire n'a pas été trouvé auprès de la CNAF."),
    'MSA' => raises(::NotFoundError, provider: 'MSA', title: 'Dossier allocataire absent MSA', detail: "Le dossier allocataire n'a pas été trouvé auprès de la MSA."),
    'RNCPS' => raises(::NotFoundError, provider: 'RNCPS', title: 'Dossier allocataire absent RNCPS', detail: "Le dossier allocataire n'a pas été trouvé auprès du RNCPS.")
  }.freeze

  def call
    resource_not_found! if http_not_found?
    unprocessable_entity_error! if http_bad_request?
    handle_http_too_many_requests! if http_too_many_requests?
    handle_internal_server_error! if http_internal_error?
    unknown_provider_response! unless valid_http_response?
    unknown_provider_response! unless valid_indicateur?
  end

  protected

  def resource_not_found!
    return sub_provider_error! if sub_provider_error?

    return regime_not_found_error(regime) if regime.present?

    unknown_provider_response!('Une erreur inattendue est survenue lors de la collecte des données')
  end

  def sub_provider_error?
    sub_provider_error_from_sngi? || sub_provider_error_from_rncps?
  end

  def sub_provider_error!
    return unprocessable_entity!(:unidentified_person, SNGI_UNIDENTIFIED_MESSAGE) if sub_provider_error_from_sngi?

    fail_with_error!(build_declared_error(ALLOCATAIRE_NOT_REFERENCED)) if sub_provider_error_from_rncps?
  end

  def regime_not_found_error(regime)
    declaration = FILE_NOT_FOUND_PER_REGIME[regime]

    fail_with_error!(build_declared_error(declaration)) if declaration
  end

  def handle_http_too_many_requests!
    fail_with_error!(build_error(ProviderRateLimitingError))
  end

  EXPECTED_BAD_REQUEST_CODES = [40_013].freeze

  def unprocessable_entity_error!
    track_unexpected_bad_request! unless EXPECTED_BAD_REQUEST_CODES.include?(error_code_from_body)

    unprocessable_entity!(:rejected_civility, meta: {
      provider_error_code: error_code_from_body,
      provider_error_message: error_message_from_body
    })
  end

  def regime
    CNAV::RetrieverOrganizer::REGIME_CODE_LABEL[response.header['X-APISECU-FD']] if response.header['X-APISECU-FD'].present?
  end

  def handle_internal_server_error!
    MonitoringService.instance.track_with_added_context(
      'warning',
      "[#{context.provider_name}] Internal server error (#{error_code_from_body})",
      {
        http_response_code: context.response.code,
        http_response_body: context.response.body,
        regime:,
        encrypted_params: encrypt_params.to_s
      }
    )

    internal_server_error!
  end

  private

  def valid_http_response?
    http_ok? && valid_json?
  end

  def valid_indicateur?
    return true if valid_indicateurs.nil?

    valid_indicateurs.include?(json_body['indicateur'])
  end

  def valid_indicateurs
    nil
  end

  def track_unexpected_bad_request!
    MonitoringService.instance.track_with_added_context(
      'warning',
      "[#{context.provider_name}] Unexpected bad request (#{error_code_from_body})",
      {
        http_response_code: context.response.code,
        http_response_body: context.response.body,
        encrypted_params: encrypt_params.to_s
      }
    )
  end

  def error_code_from_body
    json_body['errorCode']
  rescue JSON::ParserError
    'unparseable'
  end

  def error_message_from_body
    json_body['error']
  rescue JSON::ParserError
    'unparseable'
  end

  def sub_provider_error_from_sngi?
    [40_409].include?(json_body['errorCode'])
  end

  def sub_provider_error_from_rncps?
    [40_406, 40_412].include?(json_body['errorCode'])
  end
end
