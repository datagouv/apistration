class DGFIP::Dictionaries < RetrieverOrganizer
  organize DGFIP::ADELIE::Authenticate,
    DGFIP::ADELIE::Dictionnaire::MakeRequest,
    DGFIP::Dictionaries::ValidateResponse,
    DGFIP::Dictionaries::BuildResource

  def provider_name
    'DGFIP - Adélie'
  end
end
