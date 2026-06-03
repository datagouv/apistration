class CNAV::AllocationRentreeScolaire < CNAV::RetrieverOrganizer
  organize CNAV::ValidateParams,
    CNAV::Authenticate,
    CNAV::MakeRequest,
    CNAV::AllocationRentreeScolaire::ValidateResponse,
    CNAV::AllocationRentreeScolaire::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'allocation_rentree_scolaire'
  end
end
