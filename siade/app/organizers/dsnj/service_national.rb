class DSNJ::ServiceNational < RetrieverOrganizer
  organize DSNJ::ServiceNational::ValidateParams,
    DSNJ::ServiceNational::MakeRequest,
    DSNJ::ServiceNational::ValidateResponse,
    DSNJ::ServiceNational::BuildResource

  def provider_name
    'DSNJ'
  end
end
