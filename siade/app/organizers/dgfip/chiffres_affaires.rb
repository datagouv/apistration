class DGFIP::ChiffresAffaires < RetrieverOrganizer
  organize DGFIP::Authenticate,
    DGFIP::ChiffresAffaires::ValidateParams,
    DGFIP::ChiffresAffaires::MakeRequest,
    DGFIP::ChiffresAffaires::ValidateResponse,
    DGFIP::ChiffresAffaires::BuildResource

  def provider_name
    'DGFIP'
  end
end
