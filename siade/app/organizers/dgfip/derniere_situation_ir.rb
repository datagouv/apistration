class DGFIP::DerniereSituationIR < RetrieverOrganizer
  organize DGFIP::SVAIR::ValidateParams,
    DGFIP::DerniereSituationIR::Authenticate,
    DGFIP::DerniereSituationIR::MakeRequest,
    DGFIP::DerniereSituationIR::ValidateResponse,
    DGFIP::DerniereSituationIR::BuildResource

  def provider_name
    'DGFIP - SVAIR'
  end
end
