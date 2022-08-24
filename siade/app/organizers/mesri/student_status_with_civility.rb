class MESRI::StudentStatusWithCivility < RetrieverOrganizer
  organize MESRI::ValidateParamsStudentCivility,
    MESRI::StudentStatusWithCivility::MakeRequest,
    MESRI::ValidateResponse,
    MESRI::BuildResource

  def provider_name
    'MESRI'
  end
end
