class APIParticulier::V2::CNAV::QuotientFamilialV2Controller < APIParticulier::V2::CNAV::AbstractController
  protected

  def operation_id
    'api_particulier_v2_cnav_quotient_familial_v2'
  end

  def retriever
    ::CNAV::QuotientFamilialV2
  end
end
