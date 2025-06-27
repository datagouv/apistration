class INPI::RNE::ExtraitDownload < RetrieverOrganizer
  organize ValidateSiren,
    INPI::RNE::Authenticate,
    INPI::RNE::ExtraitDownload::MakeRequest,
    INPI::RNE::Download::ValidateResponse,
    INPI::RNE::ExtraitDownload::UploadDocument,
    INPI::RNE::Download::BuildResource

  def provider_name
    'INPI - RNE'
  end
end
