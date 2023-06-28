class CNAF::QuotientFamilialV2 < RetrieverOrganizer
  organize CNAF::ValidateParams,
    CNAF::QuotientFamilialV2::Authenticate,
    CNAF::QuotientFamilialV2::MakeRequest,
    CNAF::QuotientFamilialV2::ValidateResponse,
    CNAF::QuotientFamilialV2::BuildResource

  def provider_name
    'CNAF'
  end
end
