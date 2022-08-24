class CNOUS::StudentScholarshipWithCivility < RetrieverOrganizer
  organize CNOUS::ValidateParamsStudentCivility,
    CNOUS::Authenticate,
    CNOUS::StudentScholarshipWithCivility::MakeRequest,
    CNOUS::ValidateResponse,
    CNOUS::BuildResource

  def provider_name
    'CNOUS'
  end
end
