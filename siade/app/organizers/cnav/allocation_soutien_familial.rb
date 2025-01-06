class CNAV::AllocationSoutienFamilial < CNAV::RetrieverOrganizer
  organize CNAV::ValidateParams,
    CNAV::Authenticate,
    CNAV::MakeRequest,
    CNAV::ValidateResponse,
    CNAV::AllocationSoutienFamilial::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'allocation_soutien_familial'
  end
end
