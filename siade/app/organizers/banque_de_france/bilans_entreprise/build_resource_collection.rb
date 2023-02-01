class BanqueDeFrance::BilansEntreprise::BuildResourceCollection < ApplicationOrganizer
  around do |interactor|
    interactor.call unless staging?
  end

  organize BanqueDeFrance::BilansEntreprise::BuildResourceCollectionWithoutDictionaries,
    BanqueDeFrance::BilansEntreprise::RetrieveDictionariesFromCacheOrRemote,
    BanqueDeFrance::BilansEntreprise::EnrichResourceCollectionWithDictionaries
end
