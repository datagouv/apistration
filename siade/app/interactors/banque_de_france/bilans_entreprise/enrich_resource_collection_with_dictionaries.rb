class BanqueDeFrance::BilansEntreprise::EnrichResourceCollectionWithDictionaries < ApplicationInteractor
  def call
    resource_collection.each do |resource|
      enrich!(resource)
    end
  end

  private

  def enrich!(resource)
    DGFIP::LiassesFiscales::EnrichResourceWithDictionary.call(
      declarations: resource.declarations,
      dictionaries: context.dictionaries,
      default_dictionary_key: resource.date_arrete_exercice
    )
  end

  def resource_collection
    context.bundled_data.data
  end
end
