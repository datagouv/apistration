class DataSubvention::Subventions < RetrieverOrganizer
  organize ValidateSirenOrSiretOrRNA,
    DataSubvention::Subventions::Authenticate,
    DataSubvention::Subventions::MakeRequest,
    DataSubvention::Subventions::ValidateResponse,
    DataSubvention::Subventions::BuildResourceCollection

  def provider_name
    'DataSubvention'
  end
end
