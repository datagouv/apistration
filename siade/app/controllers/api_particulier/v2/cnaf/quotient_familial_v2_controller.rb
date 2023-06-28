class APIParticulier::V2::CNAF::QuotientFamilialV2Controller < APIParticulier::V2::AbstractCNAFController
  protected

  def operation_id
    'api_particulier_v2_cnaf_quotient_familial_v2'
  end

  def retriever
    ::CNAF::QuotientFamilialV2
  end
end
