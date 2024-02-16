class PoleEmploi::Indemnites < RetrieverOrganizer
  organize PoleEmploi::ValidateParams,
    PoleEmploi::Authenticate,
    PoleEmploi::Indemnites::MakeRequest,
    PoleEmploi::Indemnites::ValidateResponse,
    PoleEmploi::Indemnites::BuildResource

  def provider_name
    'France Travail'
  end
end
