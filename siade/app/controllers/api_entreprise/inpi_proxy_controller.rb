class APIEntreprise::INPIProxyController < APIController
  attr_reader :decrypted_params

  prepend_before_action :decrypt_params!

  def show
    render json: { error: 'Le lien a expiré. La durée de validité est de 1 heure.' }, status: :gone and return if expired_uuid?

    if organizer.success?
      render json: serializer.new(organizer.bundled_data).serializable_hash, status: :ok
    else
      render json: ::ErrorsSerializer.new(organizer.errors).as_json, status: :unprocessable_entity
    end
  end

  private

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

  def decrypt_params!
    decrypted_json = StringEncryptorService.instance.decrypt_url_safe(uuid)

    @decrypted_params ||= JSON.parse(decrypted_json)
  rescue ActiveSupport::MessageEncryptor::InvalidMessage, ArgumentError
    render json: { error: 'UUID Invalide' }, status: :unprocessable_entity

    false
  end

  def authenticate_user!
    @current_user = JwtUser.new(**Token.find(token_id).to_jwt_user_attributes)
  end

  def uuid
    params.require(:uuid)
  end
end
