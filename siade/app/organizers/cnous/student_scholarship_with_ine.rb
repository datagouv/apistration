class CNOUS::StudentScholarshipWithINE < RetrieverOrganizer
  organize ServiceUser::ValidateINE,
    ServiceUser::ValidateUserId,
    CNOUS::Authenticate,
    CNOUS::StudentScholarshipWithINE::MakeRequest,
    CNOUS::ValidateResponse,
    CNOUS::BuildResource

  def provider_name
    'CNOUS'
  end

  def params_kind
    'ine'
  end
end
