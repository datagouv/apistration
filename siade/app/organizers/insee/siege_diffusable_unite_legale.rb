class INSEE::SiegeDiffusableUniteLegale < RetrieverOrganizer
  organize ValidateSiren,
    INSEE::Authenticate,
    INSEE::SiegeUniteLegale::MakeRequest,
    INSEE::SiegeDiffusableUniteLegale::ValidateResponse,
    INSEE::SiegeDiffusableUniteLegale::BuildResource

  def provider_name
    'INSEE'
  end
end
