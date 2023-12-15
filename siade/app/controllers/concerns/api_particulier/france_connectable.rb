module APIParticulier::FranceConnectable
  attr_reader :france_connect_service_user_identity, :france_connect_client_attributes

  def france_connect_organizer
    @france_connect_organizer ||= FranceConnect::DataFetcherThroughAccessToken.call(params: { token: bearer_token_from_headers })
  end

  protected

  def authenticate_user!
    if bearer_token_from_headers
      handle_france_connect_flow
    else
      super
    end
  end

  private

  def handle_france_connect_flow
    if france_connect_organizer.success?
      @france_connect_service_user_identity = france_connect_organizer.service_user_identity
      @france_connect_client_attributes = france_connect_organizer.client_attributes
      @current_user = france_connect_organizer.user
    else
      render_errors(france_connect_organizer)
      false
    end
  end

  def render_errors(organizer)
    track_invalid_parameters_error_for_france_connect(organizer, organizer.errors) if france_connect? && at_least_one_error_kind_of?(:wrong_parameter, organizer)

    super(organizer)
  end

  def track_invalid_parameters_error_for_france_connect(organizer, errors)
    MonitoringService.instance.track(
      'error',
      'Invalid params with FranceConnect',
      {
        provider_name: organizer.provider_name,
        errors: errors.map(&:to_h)
      }
    )
  end

  def france_connect?
    france_connect_service_user_identity.present?
  end
end
