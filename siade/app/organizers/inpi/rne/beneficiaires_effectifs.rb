class INPI::RNE::BeneficiairesEffectifs < RetrieverOrganizer
  organize ValidateSiren,
    INPI::RNE::Authenticate,
    INPI::RNE::BeneficiairesEffectifs::MakeRequest,
    INPI::RNE::BeneficiairesEffectifs::ValidateResponse,
    INPI::RNE::BeneficiairesEffectifs::BuildResourceCollection

  def provider_name
    'INPI - RNE'
  end
end
