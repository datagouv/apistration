class MEN::Scolarites < RetrieverOrganizer
  organize MEN::Scolarites::ValidateParams,
    MEN::Scolarites::Authenticate,
    MEN::Scolarites::MakeRequest,
    MEN::Scolarites::ValidateResponse,
    MEN::Scolarites::BuildResource

  def provider_name
    'MEN'
  end
end
