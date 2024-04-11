class CNAV::QuotientFamilialV2 < CNAV::RetrieverOrganizer
  REGIME_CODE_MSA = '00171001'.freeze
  REGIME_CODE_CNAV = '00810011'.freeze

  REGIME_CODE_LABEL = {
    REGIME_CODE_MSA => 'MSA',
    REGIME_CODE_CNAV => 'CNAV'
  }.freeze

  organize CNAV::QuotientFamilialV2::ValidateParams,
    CNAV::ExtractCodeCommuneFromTranscogage,
    CNAV::Authenticate,
    CNAV::QuotientFamilialV2::MakeRequest,
    CNAV::QuotientFamilialV2::ValidateResponse,
    CNAV::QuotientFamilialV2::BuildResource

  def provider_name
    'CNAV & MSA'
  end

  def dss_prestation_name
    'quotient_familial_v2'
  end
end
