class BanqueDeFrance::BilansEntreprise::RetrieveDictionariesFromCacheOrRemote < ApplicationInteractor
  def call
    context.dictionaries = bilans_years.index_with do |year|
      retrieve_dictionaries_for_year(year)
    end
  end

  private

  def retrieve_dictionaries_for_year(year)
    retriever = DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote.call(params: { year:, request_id:, user_id: })

    return retriever.dictionary if retriever.success?

    context.errors = retriever.errors
    context.fail!
  end

  def bilans_years
    context.bundled_data.data.map(&:annee)
  end

  def request_id
    context.params.fetch(:request_id)
  end

  def user_id
    context.params.fetch(:user_id)
  end
end
