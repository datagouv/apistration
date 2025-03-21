class CNAV::QuotientFamilialV2 < CNAV::RetrieverOrganizer
  organize CNAV::QuotientFamilialV2::ValidateParams,
    CNAV::Authenticate,
    CNAV::QuotientFamilialV2::MakeRequest,
    CNAV::ValidateResponse,
    CNAV::QuotientFamilialV2::BuildResource

  def provider_name
    'CNAF & MSA'
  end

  def dss_prestation_name
    'quotient_familial_v2'
  end
end
