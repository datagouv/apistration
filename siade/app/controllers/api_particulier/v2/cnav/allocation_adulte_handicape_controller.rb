class APIParticulier::V2::CNAV::AllocationAdulteHandicapeController < APIParticulier::V2::CNAV::AbstractController
  protected

  def operation_id
    'api_particulier_v2_cnav_allocation_adulte_handicape'
  end

  def retriever
    ::CNAV::AllocationAdulteHandicape
  end
end
