class SDH::StatutSportif < RetrieverOrganizer
  organize SDH::ValidateIdentifiant,
    MockedInteractor

  def provider_name
    'SDH'
  end
end
