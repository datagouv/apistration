class DGFIP::SituationIR < RetrieverOrganizer
  organize DGFIP::SVAIR::ValidateParams,
    DGFIP::SituationIR::Authenticate,
    DGFIP::SituationIR::MakeRequest,
    DGFIP::SituationIR::ValidateResponse,
    DGFIP::SituationIR::BuildResource

  def provider_name
    'DGFIP - SVAIR'
  end
end
