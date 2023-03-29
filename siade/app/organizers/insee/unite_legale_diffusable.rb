class INSEE::UniteLegaleDiffusable < RetrieverOrganizer
  organize ValidateSiren,
    INSEE::Authenticate,
    INSEE::UniteLegale::MakeRequest,
    INSEE::UniteLegaleDiffusable::ValidateResponse,
    INSEE::UniteLegaleDiffusable::BuildResource

  def provider_name
    'INSEE'
  end
end
