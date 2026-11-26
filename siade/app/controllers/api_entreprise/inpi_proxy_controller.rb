class APIEntreprise::INPIProxyController < APIEntreprise::DownloadProxyController
  private

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
end
