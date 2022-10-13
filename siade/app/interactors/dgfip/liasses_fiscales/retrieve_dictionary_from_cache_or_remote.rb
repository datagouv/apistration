class DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote < ApplicationInteractor
  before do
    context.errors ||= []
  end

  def call
    if retriever.errors.present?
      context.errors << retriever.errors
      context.fail!
    else
      context.dictionary = retriever.bundled_data.data.dictionnaire
    end
  end

  private

  def retriever
    CacheResourceRetriever.call(
      retriever_organizer:,
      retriever_params:,
      cache_key:,
      expires_in:
    )
  end

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
