class CNAF::QuotientFamilialV2 < CNAF::RetrieverOrganizer
  REGIME_CODE_MSA = '00171001'.freeze
  REGIME_CODE_CNAF = '00810011'.freeze

  REGIME_CODE_LABEL = {
    REGIME_CODE_MSA => 'MSA',
    REGIME_CODE_CNAF => 'CNAF'
  }.freeze

  organize CNAF::QuotientFamilialV2::ValidateParams,
    CNAF::ExtractCodeCommuneFromTranscogage,
    CNAF::Authenticate,
    CNAF::QuotientFamilialV2::MakeRequest,
    CNAF::QuotientFamilialV2::ValidateResponse,
    CNAF::QuotientFamilialV2::BuildResource

  def provider_name
    'CNAF & MSA'
  end

  def dss_prestation_name
    'quotient_familial_v2'
  end
end
