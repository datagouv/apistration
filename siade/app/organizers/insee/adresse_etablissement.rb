class INSEE::AdresseEtablissement < RetrieverOrganizer
  organize ValidateSiret,
    INSEE::Authenticate,
    INSEE::Etablissement::MakeRequest,
    INSEE::Etablissement::ValidateResponse,
    INSEE::AdresseEtablissement::BuildResource

  def provider_name
    'INSEE'
  end
end
