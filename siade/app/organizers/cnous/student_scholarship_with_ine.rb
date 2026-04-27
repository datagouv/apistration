class CNOUS::StudentScholarshipWithINE < RetrieverOrganizer
  organize ServiceUser::ValidateINE,
    CNOUS::ValidateCampaignYear,
    CNOUS::Authenticate,
    CNOUS::StudentScholarshipWithINE::MakeRequest,
    CNOUS::ValidateResponse,
    CNOUS::BuildResource

  def provider_name
    'CNOUS'
  end
end
