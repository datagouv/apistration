class INSEE::SiegeUniteLegale < RetrieverOrganizer
  organize ValidateSiren,
    INSEE::Authenticate,
    INSEE::SiegeUniteLegale::MakeRequest,
    INSEE::SiegeUniteLegale::ValidateResponse,
    INSEE::SiegeUniteLegale::BuildResource

  def provider_name
    'INSEE'
  end
end
