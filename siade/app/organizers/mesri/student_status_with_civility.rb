class MESRI::StudentStatusWithCivility < RetrieverOrganizer
  organize ValidateParams::StudentCivility,
    MESRI::StudentStatusWithCivility::MakeRequest,
    MESRI::ValidateResponse,
    MESRI::BuildResource

  def provider_name
    'MESRI'
  end
end
