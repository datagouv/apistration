class BanqueDeFrance::BilansEntreprise::RetrieveDictionariesFromCacheOrRemote < ApplicationInteractor
  def call
    context.dictionaries = bilans_years.each_with_object({}) do |year, hash|
      hash[year] = retrieve_dictionaries_for_year(year)
    end
  end

  private

  def retrieve_dictionaries_for_year(year)
    retriever = DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote.call(params: { year: })

    return retriever.dictionary if retriever.success?

    context.errors = retriever.errors
    context.fail!
  end

  def bilans_years
    context.bundled_data.data.map(&:annee)
  end
end
