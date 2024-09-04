class FranceTravail::Statut < RetrieverOrganizer
  organize FranceTravail::ValidateParams,
    FranceTravail::Authenticate,
    FranceTravail::Statut::MakeRequest,
    FranceTravail::Statut::ValidateResponse,
    FranceTravail::Statut::BuildResource

  def provider_name
    'France Travail'
  end
end
