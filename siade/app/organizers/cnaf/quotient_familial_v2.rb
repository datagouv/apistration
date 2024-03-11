class CNAF::QuotientFamilialV2 < RetrieverOrganizer
  REGIME_CODE_MSA = '00171001'.freeze
  REGIME_CODE_CNAF = '00810011'.freeze

  REGIME_CODE_LABEL = {
    REGIME_CODE_MSA => 'MSA',
    REGIME_CODE_CNAF => 'CNAF'
  }.freeze

  organize CNAF::ValidateParams,
    CNAF::QuotientFamilialV2::Authenticate,
    CNAF::QuotientFamilialV2::MakeRequest,
    CNAF::QuotientFamilialV2::ValidateResponse,
    CNAF::QuotientFamilialV2::BuildResource

  def provider_name
    'CNAF & MSA'
  end
end
