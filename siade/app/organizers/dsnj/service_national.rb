class DSNJ::ServiceNational < RetrieverOrganizer
  organize DSNJ::ServiceNational::ValidateParams,
    MockedInteractor

  def provider_name
    'DSNJ'
  end
end
