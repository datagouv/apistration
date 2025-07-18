class INPI::RNE::ExtraitDownload < RetrieverOrganizer
  organize ValidateSiren,
    INPI::RNE::Authenticate,
    INPI::RNE::ExtraitDownload::MakeRequest,
    INPI::RNE::Download::ValidateResponse,
    INPI::RNE::ExtraitDownload::UploadDocument,
    INPI::RNE::Download::BuildResource

  # Map document_id to siren for extrait downloads
  before do
    context.params[:siren] = context.params[:document_id] if context.params[:document_id] && !context.params[:siren]
  end

  def provider_name
    'INPI - RNE'
  end
end
