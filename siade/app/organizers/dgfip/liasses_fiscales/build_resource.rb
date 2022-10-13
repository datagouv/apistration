class DGFIP::LiassesFiscales::BuildResource < ApplicationOrganizer
  organize DGFIP::LiassesFiscales::BuildResourceWithoutDictionary,
    DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote,
    DGFIP::LiassesFiscales::EnrichResourceWithDictionary
end
