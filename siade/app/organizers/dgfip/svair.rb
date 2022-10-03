class DGFIP::SVAIR < RetrieverOrganizer
  organize DGFIP::SVAIR::ValidateParams,
    DGFIP::SVAIR::MakeRequest,
    DGFIP::SVAIR::ValidateResponse,
    DGFIP::SVAIR::BuildResource

  def provider_name
    'DGFIP - SVAIR'
  end
end
