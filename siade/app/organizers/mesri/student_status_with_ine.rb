class MESRI::StudentStatusWithINE < RetrieverOrganizer
  organize ServiceUser::ValidateINE,
    ServiceUser::ValidateTokenId,
    MESRI::StudentStatusWithINE::MakeRequest,
    MESRI::ValidateResponse,
    MESRI::BuildResource

  def provider_name
    'MESRI'
  end
end
