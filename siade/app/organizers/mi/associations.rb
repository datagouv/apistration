class MI::Associations < RetrieverOrganizer
  organize ValidateAssociationId,
           MI::Associations::MakeRequest,
           MI::Associations::ValidateResponse,
           MI::Associations::BuildResource

  def provider_name
    'MI'
  end
end
