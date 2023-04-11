class INSEE::EtablissementDiffusable < RetrieverOrganizer
  organize ValidateSiret,
    INSEE::Authenticate,
    INSEE::Etablissement::MakeRequest,
    INSEE::EtablissementDiffusable::ValidateResponse,
    INSEE::Etablissement::BuildResource

  def provider_name
    'INSEE'
  end
end
