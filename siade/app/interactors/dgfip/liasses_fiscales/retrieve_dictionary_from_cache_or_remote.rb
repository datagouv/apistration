class DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote < ApplicationInteractor
  def call
    retriever = CacheResourceRetriever.call(
      retriever_organizer:,
      retriever_params:,
      cache_key:,
      expires_in:
    )

    context.dictionary = retriever.bundled_data.data.dictionnaire
  end

  private

  def retriever_organizer
    DGFIP::Dictionaries
  end

  def retriever_params
    context.params
  end

  def cache_key
    "dgfip:dictionnaires:#{year}"
  end

  def year
    context.params[:year]
  end

  def expires_in
    6.months.from_now
  end
end
