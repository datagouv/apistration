class MESRI::Scolarites < RetrieverOrganizer
  organize MESRI::Scolarites::ValidateParams,
    MESRI::Scolarites::Authenticate,
    MESRI::Scolarites::MakeRequest,
    MESRI::Scolarites::ValidateResponse,
    MESRI::Scolarites::BuildResource

  def provider_name
    'MESRI'
  end
end
