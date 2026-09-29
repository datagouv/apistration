class FranceConnect::ValidateResponse < ValidateResponse
  raises ProviderUnprocessableEntityError, reason: :unusable_identity

  def call
    handle_invalid_token_error if [400, 401].include?(http_code)
    unknown_provider_response! if invalid_json?
    fail_if_unprocessable_params_in_response!

    return if http_ok?

    unknown_provider_response!
  end

  protected

  def params_to_verify
    NotImplementedError
  end

  def use_mocked_data?
    context.mocked_data.present?
  end

  def fail_if_unprocessable_params_in_response!
    organizer = FranceConnect::ValidateParams.call(params: params_to_verify)

    return if organizer.success?

    track_invalid_parameters_error_for_france_connect(organizer)
    unprocessable_entity!(:unusable_identity, organizer.errors.first.detail)
  end

  def track_invalid_parameters_error_for_france_connect(organizer)
    MonitoringService.instance.track_with_added_context(
      'error',
      'Invalid params with FranceConnect',
      {
        provider_name: organizer.provider_name,
        errors: organizer.errors.map(&:to_h)
      }
    )
  end
end
