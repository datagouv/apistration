class APIParticulier::V2::BaseController < APIController
  before_action :verify_recipient_is_a_siret_or_nil!

  include RecipientManagement
  include UseRetrievers

  protected

  def cache_key
    "#{request.path}:#{organizer_params.to_query}"
  end

  def serialize_data
    if organizer.mocked_data.present?
      organizer.mocked_data[:payload]
    else
      serializer_class.new(organizer.bundled_data.data, serializer_base_options).serializable_hash
    end
  end

  def serializer_class
    api_version, provider_name, resource_controller_name = self.class.to_s.split('::')[1..3]
    resource_name = resource_controller_name.sub('Controller', '')

    APIParticulier.const_get("#{provider_name}::#{resource_name}::#{api_version}")
  end

  def serializer_base_options
    {
      scope: current_user,
      scope_name: :current_user
    }
  end

  def render_errors(organizer)
    render content_type: 'application/json',
      json: format_error(organizer.errors.first),
      status: extract_http_code(organizer)
  end

  def verify_recipient_is_a_siret_or_nil!
    return if params[:recipient].blank?

    verify_recipient_is_a_siret!
  end

  def verify_recipient_is_a_siret!
    return if recipient_is_a_siret?

    raise_invalid_recipient!
  end

  def raise_invalid_recipient!
    render json: format_error(InvalidRecipientError.new),
      status: :bad_request
  end

  private

  def user_not_authorized(exception)
    case exception
    when NotValidTokenError
      render json: format_unauthorized_error(InvalidTokenError.new),
        status: :unauthorized
    when NotAuthorizedError
      render json: format_unauthorized_error(InsufficientPrivilegesError.new('api_particulier')),
        status: :unauthorized
    else
      raise 'Invalid exception class', exception.class
    end
  end

  def extract_http_code(organizer)
    if at_least_one_error_kind_of?(:wrong_parameter, organizer)
      :bad_request
    elsif at_least_one_error_kind_of?(%i[provider_error provider_unknown_error], organizer)
      :service_unavailable
    else
      super
    end
  end

  def format_error(error)
    send("format_#{error.kind}_error", error)
  rescue NoMethodError
    {
      error: error.kind,
      reason: error.detail,
      message: error.detail
    }
  end

  def format_wrong_parameter_error(error)
    {
      error: 'bad_request',
      reason: error.detail,
      message: error.detail
    }
  end

  def format_unauthorized_error(error)
    {
      error: 'access_denied',
      reason: error.detail,
      message: error.detail
    }
  end

  def format_provider_error_error(error)
    {
      error: 'data_provider_error',
      reason: error.detail,
      message: error.detail
    }
  end

  def token_from_headers
    request.headers['X-Api-key']
  end

  def error_format
    'flat'
  end

  def api_version
    2
  end
end
