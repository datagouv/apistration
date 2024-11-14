class DGFIP::LiassesFiscales < RetrieverOrganizer
  organize DGFIP::LiassesFiscales::ValidateParams,
    DGFIP::ADELIE::Authenticate,
    DGFIP::ADELIE::LiasseFiscale::MakeRequest,
    DGFIP::LiassesFiscales::ValidateResponse,
    DGFIP::LiassesFiscales::BuildResource

  def provider_name
    'DGFIP - Adélie'
  end
end
