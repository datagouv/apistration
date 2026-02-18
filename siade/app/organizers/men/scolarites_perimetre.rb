class MEN::ScolaritesPerimetre < RetrieverOrganizer
  organize MEN::ScolaritesPerimetre::ValidateParams,
    MEN::Scolarites::Authenticate,
    MEN::ScolaritesPerimetre::MakeRequest,
    MEN::Scolarites::ValidateResponse,
    MEN::Scolarites::BuildResource

  def provider_name
    'MEN'
  end
end
