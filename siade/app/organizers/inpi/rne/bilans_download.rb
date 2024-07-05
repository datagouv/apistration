class INPI::RNE::BilansDownload < RetrieverOrganizer
  organize INPI::RNE::ValidateDocumentId,
    INPI::RNE::Authenticate,
    INPI::RNE::BilansDownload::MakeRequest,
    INPI::RNE::Download::ValidateResponse,
    INPI::RNE::BilansDownload::UploadDocument,
    INPI::RNE::Download::BuildResource

  def provider_name
    'INPI - RNE'
  end
end
