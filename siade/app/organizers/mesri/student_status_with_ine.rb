class MESRI::StudentStatusWithINE < RetrieverOrganizer
  organize MESRI::StudentStatusWithINE::ValidateParams,
    MESRI::StudentStatusWithINE::MakeRequest,
    MESRI::ValidateResponse,
    MESRI::BuildResource

  def provider_name
    'MESRI'
  end
end
