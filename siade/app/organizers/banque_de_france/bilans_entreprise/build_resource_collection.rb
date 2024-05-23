class BanqueDeFrance::BilansEntreprise::BuildResourceCollection < ApplicationOrganizer
  around do |interactor|
    interactor.call unless clogged_env?
  end

  organize BanqueDeFrance::BilansEntreprise::BuildResourceCollectionWithoutDictionaries,
    BanqueDeFrance::BilansEntreprise::RetrieveDictionariesFromCacheOrRemote,
    BanqueDeFrance::BilansEntreprise::EnrichResourceCollectionWithDictionaries
end
