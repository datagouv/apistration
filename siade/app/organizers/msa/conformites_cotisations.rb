class MSA::ConformitesCotisations < RetrieverOrganizer
  organize ValidateSiret,
    MSA::ConformitesCotisations::MakeRequest,
    MSA::ConformitesCotisations::ValidateResponse,
    MSA::ConformitesCotisations::BuildResource

  def provider_name
    'MSA'
  end
end
