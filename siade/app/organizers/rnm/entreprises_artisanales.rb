class RNM::EntreprisesArtisanales < RetrieverOrganizer
  organize ValidateSiren,
           RNM::EntreprisesArtisanales::MakeRequest,
           RNM::EntreprisesArtisanales::ValidateResponse,
           RNM::EntreprisesArtisanales::BuildResource
end
