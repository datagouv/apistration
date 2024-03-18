class APIParticulier::V2::CNAF::RevenuSolidariteActiveController < APIParticulier::V2::CNAF::AbstractController
  protected

  def operation_id
    'api_particulier_v2_cnaf_revenu_solidarite_active'
  end

  def retriever
    ::CNAF::RevenuSolidariteActive
  end
end
