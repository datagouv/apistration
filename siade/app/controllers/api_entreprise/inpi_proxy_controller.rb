class APIEntreprise::INPIProxyController < APIController
  include OrganizersMethodsHelpers

  attr_reader :decrypted_params

  prepend_before_action :decrypt_params
  before_action :check_uuid_timestamp

  def show
    if organizer.success?
      render json: serializer.new(organizer.bundled_data, current_user).serializable_hash, status: :ok
    else
      render_errors(organizer)
    end
  end

  private

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
    handle_params_error!([UnprocessableEntityError.new(:uuid)], :unprocessable_entity)
  end

  def check_uuid_timestamp
    handle_params_error!([ExpiredLinkError.new('Ce lien expire après 1 heure.')], :gone) if expired_uuid?
  end

  def authenticate_user!
    @current_user = JwtUser.new(**Token.find(token_id).to_jwt_user_attributes)
  rescue ActiveRecord::RecordNotFound
    handle_params_error!([TokenNotFoundError.new], :unauthorized)
  end

  def organizer
    retriever.call(params: organizer_params)
  end

  def retriever
    "INPI::RNE::#{target.capitalize}Download".constantize
  end

  def serializer
    "::APIEntreprise::INPI::RNE::#{target.capitalize}DownloadSerializer::V3".constantize
  end

  def organizer_params
    {
      document_id:
    }
  end

  def target
    decrypted_params['target']
  end

  def document_id
    decrypted_params['document_id']
  end

  def timestamp
    decrypted_params['timestamp']
  end

  def token_id
    decrypted_params['token_id']
  end

  def expired_uuid?
    Time.zone.now.to_i - timestamp.to_i > 1.hour
  end

  def uuid
    params.require(:uuid)
  end
end
