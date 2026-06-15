class DGFIP::TVA < RetrieverOrganizer
  organize ValidateSiren,
    DGFIP::TVA::BuildTVANumberFromSiren,
    DGFIP::TVA::MakeRequest,
    DGFIP::TVA::ValidateResponse,
    DGFIP::TVA::FetchRefreshDate,
    DGFIP::TVA::BuildResource

  def provider_name
    'DGFIP - TVA'
  end
end
