module APIParticulier::FranceConnectable
  extend ActiveSupport::Concern

  attr_reader :france_connect_service_user_identity, :france_connect_client_attributes

  included do
    before_action :verify_recipient_is_a_siret!, if: :france_connect?
  end

  def france_connect_organizer
    @france_connect_organizer ||= FranceConnectOrganizerService.new(bearer_token_from_headers).fetch
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
    track_invalid_parameters_error_for_france_connect(organizer, organizer.errors) if invalid_france_connect_parameters_error?(organizer)
    super
  end

  def invalid_france_connect_parameters_error?(organizer)
    france_connect? && at_least_one_error_kind_of?(:wrong_parameter, organizer) && wrong_params_from_france_connect?(organizer.errors)
  end

  def wrong_params_from_france_connect?(errors)
    errors.any? { |error| error.is_a?(UnprocessableEntityError) && whitelisted_non_france_connect_parameters.exclude?(error.field) }
  end

  def whitelisted_non_france_connect_parameters
    %i[
      recipient
    ]
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
