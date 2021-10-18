class INSEE::EntrepriseDiffusable < RetrieverOrganizer
  organize ValidateSiren,
    INSEE::Authenticate,
    INSEE::Entreprise::MakeRequest,
    INSEE::EntrepriseDiffusable::ValidateResponse,
    INSEE::Entreprise::BuildResource

  def provider_name
    'INSEE'
  end
end
