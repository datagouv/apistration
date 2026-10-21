class MI::SIAF::Fondations < RetrieverOrganizer
  organize MI::SIAF::Fondations::ValidateParams,
    MI::SIAF::Fondations::MakeRequest,
    MI::SIAF::Fondations::ValidateResponse,
    MI::SIAF::Fondations::BuildResource

  def provider_name
    'SIAF'
  end
end
