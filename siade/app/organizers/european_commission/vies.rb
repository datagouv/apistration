class EuropeanCommission::VIES < RetrieverOrganizer
  organize ValidateSiren,
    EuropeanCommission::VIES::BuildTVANumberFromSiren,
    EuropeanCommission::VIES::MakeRequest,
    EuropeanCommission::VIES::ValidateResponse,
    EuropeanCommission::VIES::BuildResource

  def provider_name
    'Commission Européenne'
  end
end
