class CNOUS::StudentScholarshipWithCivility < RetrieverOrganizer
  organize CNOUS::StudentScholarshipWithCivility::ValidateParams,
    CNOUS::ValidateCampaignYear,
    CNOUS::Authenticate,
    CNOUS::StudentScholarshipWithCivility::MakeRequest,
    CNOUS::ValidateResponse,
    CNOUS::BuildResource

  def provider_name
    'CNOUS'
  end
end
