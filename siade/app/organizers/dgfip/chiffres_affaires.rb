class DGFIP::ChiffresAffaires < RetrieverOrganizer
  organize DGFIP::ChiffresAffaires::ValidateParams,
    DGFIP::ADELIE::Authenticate,
    DGFIP::ADELIE::ChiffreAffaires::MakeRequest,
    DGFIP::ChiffresAffaires::ValidateResponse,
    DGFIP::ChiffresAffaires::BuildResource

  def provider_name
    'DGFIP - Adélie'
  end
end
