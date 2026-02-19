class CNAV::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    unprocessable_entity_error! if http_bad_request?
    handle_http_too_many_requests! if http_too_many_requests?
    handle_internal_server_error! if http_internal_error?
    unknown_provider_response! if !http_ok? || invalid_json?
  end

  protected

  def resource_not_found!
    return sub_provider_error! if sub_provider_error?

    return regime_not_found_error(regime) if regime.present?

    fail_with_error!(build_qfv2_error(::NotFoundError, context.provider_name, 'Une erreur inattendue est survenue lors de la collecte des données', 'Erreur inatendue'))
  end

  def sub_provider_error?
    sub_provider_error_from_sngi? || sub_provider_error_from_rncps?
  end

  def sub_provider_error!
    return fail_with_error!(UnprocessableEntityError.new(:sngi)) if sub_provider_error_from_sngi?

    fail_with_error!(build_qfv2_error(::NotFoundError, 'CNAF & MSA', "L'allocataire n'est pas référencé auprès des caisses éligibles", 'Allocataire non référencé')) if sub_provider_error_from_rncps?
  end

  def regime_not_found_error(regime)
    return fail_with_error!(build_qfv2_error(::NotFoundError, 'CNAF', "Le dossier allocataire n'a pas été trouvé auprès de la CNAF.", 'Dossier allocataire absent CNAF')) if regime == 'CNAF'
    return fail_with_error!(build_qfv2_error(::NotFoundError, 'MSA', "Le dossier allocataire n'a pas été trouvé auprès de la MSA.", 'Dossier allocataire absent MSA')) if regime == 'MSA'

    fail_with_error!(build_qfv2_error(::NotFoundError, 'RNCPS', "Le dossier allocataire n'a pas été trouvé auprès du RNCPS.", 'Dossier allocataire absent RNCPS')) if regime == 'RNCPS'
  end

  def handle_http_too_many_requests!
    fail_with_error!(build_error(ProviderRateLimitingError))
  end

  def unprocessable_entity_error!
    fail_with_error!(::UnprocessableEntityError.new(:civility))
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

  def error_code_from_body
    json_body['errorCode']
  rescue JSON::ParserError
    'unparseable'
  end

  def sub_provider_error_from_sngi?
    [40_409].include?(json_body['errorCode'])
  end

  def sub_provider_error_from_rncps?
    [40_406, 40_412].include?(json_body['errorCode'])
  end

  def build_qfv2_error(error_klass, provider, message = nil, title = nil)
    error_klass.new(provider, message, title:, with_identifiant_message: false)
  end
end
