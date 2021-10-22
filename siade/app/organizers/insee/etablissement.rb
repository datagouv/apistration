class INSEE::Etablissement < RetrieverOrganizer
  organize ValidateSiret,
    INSEE::Authenticate,
    INSEE::Etablissement::MakeRequest,
    INSEE::Etablissement::ValidateResponse,
    INSEE::Etablissement::BuildResource

  def provider_name
    'INSEE'
  end
end
