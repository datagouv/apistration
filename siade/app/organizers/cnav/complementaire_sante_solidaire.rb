class CNAV::ComplementaireSanteSolidaire < CNAV::RetrieverOrganizer
  organize CNAV::ValidateParams,
    CNAV::Authenticate,
    CNAV::MakeRequest,
    CNAV::ValidateResponse,
    CNAV::ComplementaireSanteSolidaire::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'complementaire_sante_solidaire'
  end
end
