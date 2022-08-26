class CNOUS::StudentScholarshipWithCivility < RetrieverOrganizer
  organize CNOUS::StudentScholarshipWithCivility::ValidateParams,
    CNOUS::Authenticate,
    CNOUS::StudentScholarshipWithCivility::MakeRequest,
    CNOUS::ValidateResponse,
    CNOUS::BuildResource

  def provider_name
    'CNOUS'
  end

  def params_kind
    'civility'
  end
end
