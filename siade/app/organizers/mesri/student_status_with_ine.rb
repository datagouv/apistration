class MESRI::StudentStatusWithINE < RetrieverOrganizer
  organize MESRI::StudentStatusWithINE::ValidateParams,
    MESRI::StudentStatusWithINE::MakeRequest,
    MESRI::ValidateResponse,
    MESRI::StudentStatusWithINE::BuildResource

  def provider_name
    'MESRI'
  end
end
