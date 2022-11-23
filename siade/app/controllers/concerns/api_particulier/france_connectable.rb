module APIParticulier::FranceConnectable
  attr_reader :france_connect_service_user_identity

  protected

  def authenticate_user!
    france_connect_token = bearer_token_from_headers

    if france_connect_token
      handle_france_connect_flow(france_connect_token)
    else
      super
    end
  end

  private

  def handle_france_connect_flow(france_connect_token)
    france_connect_organizer = FranceConnect::DataFetcherThroughAccessToken.call(params: { token: france_connect_token })

    if france_connect_organizer.success?
      @france_connect_service_user_identity = france_connect_organizer.service_user_identity
      @current_user = france_connect_organizer.user
    else
      render_errors(france_connect_organizer)
      false
    end
  end

  def track_invalid_paramaters_error_for_france_connect(organizer, errors)
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
