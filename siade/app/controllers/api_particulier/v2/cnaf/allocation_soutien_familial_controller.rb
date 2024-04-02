class APIParticulier::V2::CNAF::AllocationSoutienFamilialController < APIParticulier::V2::CNAF::AbstractController
  protected

  def operation_id
    'api_particulier_v2_cnaf_allocation_soutien_familial'
  end

  def retriever
    ::CNAF::AllocationSoutienFamilial
  end
end
