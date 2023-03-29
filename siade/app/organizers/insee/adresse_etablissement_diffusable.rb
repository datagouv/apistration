class INSEE::AdresseEtablissementDiffusable < RetrieverOrganizer
  organize ValidateSiret,
    INSEE::Authenticate,
    INSEE::Etablissement::MakeRequest,
    INSEE::EtablissementDiffusable::ValidateResponse,
    INSEE::AdresseEtablissementDiffusable::BuildResource

  def provider_name
    'INSEE'
  end
end
