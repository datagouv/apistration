class BanqueDeFrance::BilansEntreprise < RetrieverOrganizer
  organize ValidateSiren,
    BanqueDeFrance::BilansEntreprise::MakeRequest,
    BanqueDeFrance::BilansEntreprise::ValidateResponse,
    BanqueDeFrance::BilansEntreprise::BuildResourceCollection

  def provider_name
    'Banque de France'
  end
end
