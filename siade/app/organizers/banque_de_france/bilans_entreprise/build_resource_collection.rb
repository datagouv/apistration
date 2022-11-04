class BanqueDeFrance::BilansEntreprise::BuildResourceCollection < ApplicationOrganizer
  organize BanqueDeFrance::BilansEntreprise::BuildResourceCollectionWithoutDictionaries,
    BanqueDeFrance::BilansEntreprise::RetrieveDictionariesFromCacheOrRemote,
    BanqueDeFrance::BilansEntreprise::EnrichResourceCollectionWithDictionaries
end
