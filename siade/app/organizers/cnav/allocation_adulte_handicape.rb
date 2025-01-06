class CNAV::AllocationAdulteHandicape < CNAV::RetrieverOrganizer
  organize CNAV::ValidateParams,
    CNAV::Authenticate,
    CNAV::MakeRequest,
    CNAV::ValidateResponse,
    CNAV::AllocationAdulteHandicape::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'allocation_adulte_handicape'
  end
end
