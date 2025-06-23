class CNOUS::ValidateResponse < ValidateResponse
  # rubocop:disable Metrics/CyclomaticComplexity
  def call
    resource_not_found! if http_not_found?
    unprocessable_entity_error! if http_bad_request?
    conflict! if conflict?
    internal_server_error! if http_internal_error?

    return if http_ok? && !invalid_json? && data_present?

    unknown_provider_response!
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def data_present?
    valid_payload['lastName'].present?
  end

  def resource_not_found!
    fail_with_error!(build_error(::NotFoundError, "Aucun étudiant boursier n'a pu être trouvé avec les critères de recherche fournis"))
  end

  def unprocessable_entity_error!
    fail_with_error!(::UnprocessableEntityError.new(params_kind))
  end

  def conflict?
    !invalid_json? && Array.wrap(json_body).many?
  end

  def conflict!
    monitoring_service.track_with_added_context('error', 'CNOUS Identity calls returned more than one result', context.params)
    fail_with_error!(::ProviderConflictError.new(context.provider))
  end

  def valid_payload
    @valid_payload ||= Array.wrap(json_body)[0]
  end

  def params_kind
    context.params[:ine].present? ? :ine : :civility
  end

  def monitoring_service
    MonitoringService.instance
  end
end
