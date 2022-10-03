class DGFIP::ChiffresAffaires < RetrieverOrganizer
  organize DGFIP::ChiffresAffaires::ValidateParams,
    DGFIP::Authenticate,
    DGFIP::ChiffresAffaires::MakeRequest,
    DGFIP::ChiffresAffaires::ValidateResponse,
    DGFIP::ChiffresAffaires::BuildResource

  def provider_name
    'DGFIP - Adélie'
  end
end
