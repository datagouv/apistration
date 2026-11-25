class APIEntreprise::DownloadProxyController < APIController
  include OrganizersMethodsHelpers

  attr_reader :decrypted_params

  prepend_before_action :decrypt_params
  before_action :check_uuid_timestamp

  def show
    if organizer.success?
      render json: serialize_data, status: :ok
    else
      render_errors(organizer)
    end
  end

  private

  def serialize_data
    if organizer.mocked_data.present?
      organizer.mocked_data[:payload]
    else
      serializer.new(organizer.bundled_data, current_user).serializable_hash
    end
  end

  def render_errors(organizer)
    render content_type: content_type_header,
      json:         ::ErrorsSerializer.new(organizer.errors).as_json,
      status:       extract_http_code(organizer)
  end

  def handle_params_error!(errors, status)
    render(json: ::ErrorsSerializer.new(errors).as_json, status:)

    false
  end

  def decrypt_params
    @decrypted_params ||= JSON.parse(StringEncryptorService.instance.decrypt_url_safe(uuid))
  rescue ActiveSupport::MessageEncryptor::InvalidMessage, ArgumentError
    handle_params_error!([UnprocessableEntityError.new(:uuid)], :unprocessable_content)
  end

  def check_uuid_timestamp
    handle_params_error!([ExpiredLinkError.new('Ce lien expire après 1 heure.')], :gone) if expired_uuid?
  end

  def authenticate_user!
    user = JwtUser.new(**token_model.find(token_id).to_jwt_user_attributes)
    @current_user = enrich_with_delegation(user)
  rescue ActiveRecord::RecordNotFound
    handle_params_error!([TokenNotFoundError.new], :unauthorized)
  end

  def enrich_with_delegation(user)
    return user unless authorization_request_id

    user.delegated_to(AuthorizationRequest.find(authorization_request_id))
  end

  def organizer
    @organizer ||= retriever.call(params: organizer_params)
  end

  def retriever
    fail NotImplementedError
  end

  def serializer
    fail NotImplementedError
  end

  def organizer_params
    fail NotImplementedError
  end

  def timestamp
    decrypted_params['timestamp']
  end

  def token_id
    decrypted_params['token_id']
  end

  def token_type
    decrypted_params['token_type']
  end

  def authorization_request_id
    decrypted_params['authorization_request_id']
  end

  def token_model
    token_type == 'editor' ? EditorToken : Token
  end

  def expired_uuid?
    Time.zone.now.to_i - timestamp.to_i > 1.hour
  end

  def uuid
    params.require(:uuid)
  end
end
