class APIEntreprise::SIAFFondationsProxyController < APIEntreprise::DownloadProxyController
  private

  def authorize_access_to_resource!
    super

    raise NotAuthorizedError unless current_user.scope?(decrypted_params['scope'])
  end

  def retriever
    ::MI::SIAF::FondationsDownload
  end

  def serializer
    ::APIEntreprise::MI::SIAF::FondationsDownloadSerializer::V3
  end

  def organizer_params
    {
      rnf: decrypted_params['rnf'],
      file_id: decrypted_params['file_id'],
      mime_type: decrypted_params['mime_type']
    }
  end
end
