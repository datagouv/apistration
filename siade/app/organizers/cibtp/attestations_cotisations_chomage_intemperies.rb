class CIBTP::AttestationsCotisationsChomageIntemperies < RetrieverOrganizer
  organize ValidateSiret,
    CIBTP::AttestationsCotisationsChomageIntemperies::Authenticate,
    CIBTP::AttestationsCotisationsChomageIntemperies::MakeRequest,
    CIBTP::AttestationsCotisationsChomageIntemperies::ValidateResponse,
    CIBTP::AttestationsCotisationsChomageIntemperies::UploadDocument,
    CIBTP::AttestationsCotisationsChomageIntemperies::BuildResource

  def provider_name
    'CIBTP'
  end
end
