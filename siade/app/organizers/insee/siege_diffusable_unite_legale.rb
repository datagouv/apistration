class INSEE::SiegeDiffusableUniteLegale < RetrieverOrganizer
  organize ValidateSiren,
    INSEE::Authenticate,
    INSEE::SiegeUniteLegale::MakeRequest,
    INSEE::SiegeDiffusableUniteLegale::ValidateResponse,
    INSEE::SiegeUniteLegale::BuildResource

  def provider_name
    'INSEE'
  end
end
