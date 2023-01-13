class MESRI::StudentStatus::WithCivility < RetrieverOrganizer
  organize MESRI::StudentStatus::WithCivility::ValidateParams,
    MESRI::StudentStatus::WithCivility::MakeRequest,
    MESRI::StudentStatus::ValidateResponse,
    MESRI::StudentStatus::BuildResource

  def provider_name
    'MESRI'
  end
end
