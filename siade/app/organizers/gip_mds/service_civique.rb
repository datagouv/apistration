class GIPMDS::ServiceCivique < RetrieverOrganizer
  organize GIPMDS::ServiceCivique::ValidateParams,
    GIPMDS::ServiceCivique::Authenticate,
    GIPMDS::ServiceCivique::MakeRequest,
    GIPMDS::ServiceCivique::ValidateResponse,
    GIPMDS::ServiceCivique::BuildResource

  def provider_name
    'GIP-MDS'
  end
end
