class INPI::RNE::ExtraitRNE < RetrieverOrganizer
  organize ValidateSiren,
    INPI::RNE::Authenticate,
    INPI::RNE::Company::MakeRequest,
    INPI::RNE::Company::ValidateResponse,
    INPI::RNE::ExtraitRNE::BuildResource

  def provider_name
    'INPI - RNE'
  end
end
