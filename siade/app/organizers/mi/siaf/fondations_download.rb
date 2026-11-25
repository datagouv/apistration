class MI::SIAF::FondationsDownload < RetrieverOrganizer
  organize MI::SIAF::FondationsDownload::MakeRequest,
    MI::SIAF::FondationsDownload::ValidateResponse,
    MI::SIAF::FondationsDownload::UploadDocument,
    MI::SIAF::FondationsDownload::BuildResource

  def provider_name
    'SIAF'
  end
end
