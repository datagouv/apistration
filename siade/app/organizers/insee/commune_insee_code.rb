class INSEE::CommuneINSEECode < RetrieverOrganizer
  organize INSEE::CommuneINSEECode::ValidateParams,
    INSEE::Authenticate,
    INSEE::Metadonnees::MakeRequest,
    INSEE::Metadonnees::ValidateResponse,
    INSEE::CommuneINSEECode::BuildResource

  def provider_name
    'INSEE'
  end
end
