class CNAF::AllocationAdulteHandicape < CNAF::RetrieverOrganizer
  organize CNAF::ValidateParams,
    CNAF::ExtractCodeCommuneFromTranscogage,
    CNAF::Authenticate,
    CNAF::MakeRequest,
    CNAF::ValidateResponse,
    CNAF::AllocationAdulteHandicape::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'allocation_adulte_handicape'
  end
end
