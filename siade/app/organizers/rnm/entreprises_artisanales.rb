class RNM::EntreprisesArtisanales < RetrieverOrganizer
  organize ValidateSiren,
           RNM::EntreprisesArtisanales::MakeRequest,
           RNM::EntreprisesArtisanales::ValidateResponse,
           RNM::EntreprisesArtisanales::BuildResource

  def provider_name
    'CMA France'
  end
end
