class DGFIP::Dictionaries < RetrieverOrganizer
  organize DGFIP::Authenticate,
    DGFIP::Dictionaries::MakeRequest,
    DGFIP::Dictionaries::ValidateResponse,
    DGFIP::Dictionaries::CacheResponse

  def provider_name
    'DGFIP - Adélie'
  end
end
