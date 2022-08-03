class CNAF::QuotientFamilial < RetrieverOrganizer
  organize CNAF::QuotientFamilial::ValidateParams,
    CNAF::QuotientFamilial::MakeRequest,
    CNAF::QuotientFamilial::ValidateResponse,
    CNAF::QuotientFamilial::BuildResource

  def provider_name
    'CNAF'
  end
end
