class CNAF::PrimeActivite < CNAF::RetrieverOrganizer
  organize CNAF::ValidateParams,
    CNAF::ExtractCodeCommuneFromTranscogage,
    CNAF::Authenticate,
    CNAF::MakeRequest,
    CNAF::ValidateResponse,
    CNAF::PrimeActivite::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'prime_activite'
  end
end
