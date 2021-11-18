class INSEE::UniteLegale < RetrieverOrganizer
  organize ValidateSiren,
    INSEE::Authenticate,
    INSEE::UniteLegale::MakeRequest,
    INSEE::UniteLegale::ValidateResponse,
    INSEE::UniteLegale::BuildResource

  def provider_name
    'INSEE'
  end
end
