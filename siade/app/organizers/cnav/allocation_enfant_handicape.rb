class CNAV::AllocationEnfantHandicape < CNAV::RetrieverOrganizer
  organize CNAV::ValidateParams,
    CNAV::Authenticate,
    CNAV::MakeRequest,
    CNAV::ValidateResponse,
    CNAV::AllocationEnfantHandicape::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'allocation_enfant_handicape'
  end
end
