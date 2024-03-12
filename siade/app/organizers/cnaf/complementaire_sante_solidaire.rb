class CNAF::ComplementaireSanteSolidaire < RetrieverOrganizer
  organize CNAF::ValidateParams,
    CNAF::ExtractCodeCommuneFromTranscogage,
    CNAF::ComplementaireSanteSolidaire::Authenticate,
    CNAF::ComplementaireSanteSolidaire::MakeRequest,
    CNAF::ComplementaireSanteSolidaire::ValidateResponse,
    CNAF::ComplementaireSanteSolidaire::BuildResource

  def provider_name
    'Sécurité sociale'
  end
end
