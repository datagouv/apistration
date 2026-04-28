class CNOUS::StudentScholarshipWithFranceConnect < RetrieverOrganizer
  organize CNOUS::ValidateCampaignYear,
    CNOUS::Authenticate,
    CNOUS::StudentScholarshipWithFranceConnect::MakeRequest,
    CNOUS::ValidateResponse,
    CNOUS::BuildResource

  def provider_name
    'CNOUS'
  end
end
