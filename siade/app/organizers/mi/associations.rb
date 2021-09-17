class MI::Associations < RetrieverOrganizer
  organize ValidateSiretOrRNA,
           MI::Associations::MakeRequest,
           MI::Associations::ValidateResponse,
           MI::Associations::BuildResource

  def provider_name
    'MI'
  end
end
