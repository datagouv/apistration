class MESRI::StudentStatusWithINE < RetrieverOrganizer
  organize ValidateParams::StudentINE,
    MESRI::StudentStatusWithINE::MakeRequest,
    MESRI::ValidateResponse,
    MESRI::BuildResource

  def provider_name
    'MESRI'
  end
end
