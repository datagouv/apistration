class INPI::RNE::ActesBilans < RetrieverOrganizer
  organize ValidateSiren,
    INPI::RNE::Authenticate,
    INPI::RNE::ActesBilans::MakeRequest,
    INPI::RNE::ActesBilans::ValidateResponse,
    INPI::RNE::ActesBilans::BuildResource

  def provider_name
    'INPI - RNE'
  end
end
