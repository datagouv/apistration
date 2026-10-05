class DGFIP::Dictionaries < RetrieverOrganizer
  organize DGFIP::ADELIE::Authenticate,
    DGFIP::ADELIE::Dictionnaire::MakeRequest,
    DGFIP::Dictionaries::ValidateResponse,
    DGFIP::Dictionaries::BuildResource,
    DGFIP::Dictionaries::CompleteWithLocalDictionary

  def provider_name
    'DGFIP - Adélie'
  end
end
