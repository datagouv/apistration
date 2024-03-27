class CNAF::ComplementaireSanteSolidaire < CNAF::RetrieverOrganizer
  organize CNAF::ValidateParams,
    CNAF::ExtractCodeCommuneFromTranscogage,
    CNAF::Authenticate,
    CNAF::MakeRequest,
    CNAF::ValidateResponse,
    CNAF::ComplementaireSanteSolidaire::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'complementaire_sante_solidaire'
  end
end
