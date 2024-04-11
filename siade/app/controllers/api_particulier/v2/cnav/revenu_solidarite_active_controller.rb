class APIParticulier::V2::CNAV::RevenuSolidariteActiveController < APIParticulier::V2::CNAV::AbstractController
  protected

  def operation_id
    'api_particulier_v2_cnav_revenu_solidarite_active'
  end

  def retriever
    ::CNAV::RevenuSolidariteActive
  end
end
