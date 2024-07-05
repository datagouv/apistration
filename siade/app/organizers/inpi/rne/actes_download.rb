class INPI::RNE::ActesDownload < RetrieverOrganizer
  organize INPI::RNE::ValidateDocumentId,
    INPI::RNE::Authenticate,
    INPI::RNE::ActesDownload::MakeRequest,
    INPI::RNE::Download::ValidateResponse,
    INPI::RNE::ActesDownload::UploadDocument,
    INPI::RNE::Download::BuildResource

  def provider_name
    'INPI - RNE'
  end
end
