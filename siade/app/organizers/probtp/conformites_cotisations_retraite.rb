class PROBTP::ConformitesCotisationsRetraite < RetrieverOrganizer
  organize ValidateSiret,
    PROBTP::ConformitesCotisationsRetraite::MakeRequest,
    PROBTP::ConformitesCotisationsRetraite::ValidateResponse,
    PROBTP::ConformitesCotisationsRetraite::BuildResource

  def provider_name
    'ProBTP'
  end
end
