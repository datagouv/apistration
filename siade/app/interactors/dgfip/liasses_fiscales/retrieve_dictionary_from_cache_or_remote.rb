class DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote < ApplicationInteractor
  def call
    if retriever.success?
      context.dictionary = retriever.bundled_data.data.dictionnaire
    else
      context.errors = retriever.errors
      context.fail!
    end
  end

  private

  def retriever
    @retriever ||= CacheResourceRetriever.call(
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
    {
      params: {
        year:,
        user_id:,
        request_id:
      }
    }
  end

  def cache_key
    "dgfip:dictionnaires:#{year}"
  end

  def year
    context.year || context.params[:year]
  end

  def user_id
    context.params.fetch(:user_id)
  end

  def request_id
    context.params.fetch(:request_id)
  end

  def expires_in
    6.months.from_now.to_i
  end
end
