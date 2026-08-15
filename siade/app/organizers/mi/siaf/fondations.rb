class MI::SIAF::Fondations < RetrieverOrganizer
  organize MI::SIAF::Fondations::ValidateParams,
    MI::SIAF::Fondations::MakeRequest

  def provider_name
    'SIAF'
  end
end
