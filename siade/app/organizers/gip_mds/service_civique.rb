class GIPMDS::ServiceCivique < RetrieverOrganizer
  organize GIPMDS::ServiceCivique::ValidateParams,
    GIPMDS::Authenticate,
    GIPMDS::ServiceCivique::MakeRequest,
    GIPMDS::ServiceCivique::ValidateResponse,
    GIPMDS::ServiceCivique::BuildResource

  def provider_name
    'GIP-MDS'
  end
end
