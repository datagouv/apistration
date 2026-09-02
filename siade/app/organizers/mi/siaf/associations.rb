class MI::SIAF::Associations < RetrieverOrganizer
  organize MI::SIAF::Associations::ValidateParams,
    MI::SIAF::Associations::MakeRequest

  def provider_name
    'SIAF'
  end
end
