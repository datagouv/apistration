class DGFIP::SituationIR < RetrieverOrganizer
  organize DGFIP::SituationIR::ValidateParams,
    DGFIP::SituationIR::Authenticate,
    DGFIP::SituationIR::MakeRequest,
    DGFIP::SituationIR::ValidateResponse,
    DGFIP::SituationIR::BuildResource

  def provider_name
    'DGFIP - SVAIR'
  end
end
