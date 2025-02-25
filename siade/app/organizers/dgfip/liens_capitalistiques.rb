class DGFIP::LiensCapitalistiques < RetrieverOrganizer
  organize DGFIP::LiassesFiscales::ValidateParams,
    DGFIP::ADELIE::Authenticate,
    DGFIP::ADELIE::LiasseFiscale::MakeRequest,
    DGFIP::LiensCapitalistiques::ValidateResponse,
    DGFIP::LiensCapitalistiques::BuildResource

  def provider_name
    'DGFIP - Adélie'
  end
end
