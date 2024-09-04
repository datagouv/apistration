class FranceTravail::Indemnites < RetrieverOrganizer
  organize FranceTravail::ValidateParams,
    FranceTravail::Authenticate,
    FranceTravail::Indemnites::MakeRequest,
    FranceTravail::Indemnites::ValidateResponse,
    FranceTravail::Indemnites::BuildResource

  def provider_name
    'France Travail'
  end
end
