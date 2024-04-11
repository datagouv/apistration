class APIParticulier::V2::CNAV::AllocationSoutienFamilialController < APIParticulier::V2::CNAV::AbstractController
  protected

  def operation_id
    'api_particulier_v2_cnav_allocation_soutien_familial'
  end

  def retriever
    ::CNAV::AllocationSoutienFamilial
  end
end
