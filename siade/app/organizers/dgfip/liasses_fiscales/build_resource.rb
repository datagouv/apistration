class DGFIP::LiassesFiscales::BuildResource < ApplicationOrganizer
  around do |interactor|
    interactor.call unless use_mocked_data?
  end

  organize DGFIP::LiassesFiscales::BuildResourceWithoutDictionary,
    DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote,
    DGFIP::LiassesFiscales::EnrichResourceWithDictionary
end
