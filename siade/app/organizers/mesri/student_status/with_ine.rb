class MESRI::StudentStatus::WithINE < RetrieverOrganizer
  organize ServiceUser::ValidateINE,
    ServiceUser::ValidateTokenId,
    MESRI::StudentStatus::WithINE::MakeRequest,
    MESRI::StudentStatus::ValidateResponse,
    MESRI::StudentStatus::BuildResource

  def provider_name
    'MESRI'
  end
end
