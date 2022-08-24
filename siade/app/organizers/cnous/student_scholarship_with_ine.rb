class CNOUS::StudentScholarshipWithINE < RetrieverOrganizer
  organize ValidateParams::StudentINE,
    CNOUS::Authenticate,
    CNOUS::StudentScholarshipWithINE::MakeRequest,
    CNOUS::ValidateResponse,
    CNOUS::BuildResource

  def provider_name
    'CNOUS'
  end
end
