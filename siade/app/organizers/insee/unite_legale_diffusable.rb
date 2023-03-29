class INSEE::UniteLegaleDiffusable < RetrieverOrganizer
  organize ValidateSiren,
    INSEE::Authenticate,
    INSEE::UniteLegale::MakeRequest,
    INSEE::UniteLegaleDiffusable::ValidateResponse,
    INSEE::UniteLegale::BuildResource,
    INSEE::UniteLegaleDiffusable::FilterResource

  def provider_name
    'INSEE'
  end
end
