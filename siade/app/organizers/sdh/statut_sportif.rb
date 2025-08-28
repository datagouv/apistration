class SDH::StatutSportif < RetrieverOrganizer
  organize SDH::ValidateIdentifiant,
    SDH::StatutSportif::Authenticate,
    SDH::StatutSportif::MakeRequest,
    SDH::StatutSportif::ValidateResponse,
    SDH::StatutSportif::BuildResource

  def provider_name
    'SDH'
  end
end
