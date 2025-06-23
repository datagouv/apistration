class INPI::RNE::BeneficiairesEffectifs < RetrieverOrganizer
  organize ValidateSiren,
    INPI::RNE::Authenticate,
    INPI::RNE::Company::MakeRequest,
    INPI::RNE::BeneficiairesEffectifs::ValidateResponse,
    INPI::RNE::BeneficiairesEffectifs::BuildResourceCollection

  def provider_name
    'INPI - RNE'
  end
end
