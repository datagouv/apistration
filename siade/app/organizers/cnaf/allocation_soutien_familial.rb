class CNAF::AllocationSoutienFamilial < CNAF::RetrieverOrganizer
  organize CNAF::ValidateParams,
    CNAF::ExtractCodeCommuneFromTranscogage,
    CNAF::Authenticate,
    CNAF::MakeRequest,
    CNAF::ValidateResponse,
    CNAF::AllocationSoutienFamilial::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def prestation_name
    'allocation_soutien_familial'
  end
end
