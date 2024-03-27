class CNAF::RevenuSolidariteActive < CNAF::RetrieverOrganizer
  organize CNAF::ValidateParams,
    CNAF::ExtractCodeCommuneFromTranscogage,
    CNAF::Authenticate,
    CNAF::MakeRequest,
    CNAF::ValidateResponse,
    CNAF::RevenuSolidariteActive::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'revenu_solidarite_active'
  end
end
