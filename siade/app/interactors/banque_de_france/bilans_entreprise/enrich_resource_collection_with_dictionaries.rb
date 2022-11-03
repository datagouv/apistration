class BanqueDeFrance::BilansEntreprise::EnrichResourceCollectionWithDictionaries < ApplicationInteractor
  def call
    resource_collection.each do |resource|
      enrich!(resource, extract_valid_dictionary_for(resource))
    end
  end

  private

  def enrich!(resource, dictionary)
    DGFIP::LiassesFiscales::EnrichResourceWithDictionary.call(
      declarations: resource.declarations,
      dictionary:
    )
  end

  def extract_valid_dictionary_for(resource)
    context.dictionaries[resource.annee]
  end

  def resource_collection
    context.bundled_data.data
  end
end
