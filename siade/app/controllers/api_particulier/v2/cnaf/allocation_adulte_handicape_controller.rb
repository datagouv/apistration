class APIParticulier::V2::CNAF::AllocationAdulteHandicapeController < APIParticulier::V2::CNAF::AbstractController
  protected

  def operation_id
    'api_particulier_v2_cnaf_allocation_adulte_handicape'
  end

  def retriever
    ::CNAF::AllocationAdulteHandicape
  end
end
