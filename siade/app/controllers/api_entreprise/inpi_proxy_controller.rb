class APIEntreprise::INPIProxyController < ApplicationController
  def show
    if expired_uuid?
      render json: { error: 'Le lien a expiré. La durée de validité est de 1 heure.' }, status: :gone
    elsif organizer.success?
      render json: serializer.new(organizer.bundled_data).serializable_hash, status: :ok
    else
      render json: ::ErrorsSerializer.new(organizer.errors).as_json, status: :unprocessable_entity
    end
  rescue ActiveSupport::MessageEncryptor::InvalidMessage, ArgumentError
    render json: { error: 'UUID Invalide' }, status: :unprocessable_entity
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
    decrypted_params.first
  end

  def document_id
    decrypted_params.second
  end

  def timestamp
    decrypted_params.third
  end

  def expired_uuid?
    Time.zone.now.to_i - timestamp.to_i > 1.hour
  end

  def decrypted_params
    @decrypted_params ||= StringEncryptorService.instance.decrypt_url_safe(uuid).split('-')
  end

  def uuid
    params.require(:uuid)
  end
end
