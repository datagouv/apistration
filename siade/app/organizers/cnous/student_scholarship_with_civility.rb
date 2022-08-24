class CNOUS::StudentScholarshipWithCivility < RetrieverOrganizer
  organize ValidateParams::StudentCivility,
    CNOUS::Authenticate,
    CNOUS::StudentScholarshipWithCivility::MakeRequest,
    CNOUS::ValidateResponse,
    CNOUS::BuildResource

  def provider_name
    'CNOUS'
  end
end
