class DGFIP::LiassesFiscales::RetrieveDictionariesWithFallback < ApplicationInteractor
  def call
    context.dictionaries = years_with_fallback_by_key.transform_values do |year, fallback_year|
      dictionary_for(year, fallback_year)
    end
  end

  protected

  def years_with_fallback_by_key
    raise NotImplementedError
  end

  private

  def dictionary_for(year, fallback_year)
    return retriever(year).dictionary if available?(retriever(year))
    return retriever(fallback_year).dictionary if retriever(fallback_year).success?

    context.errors = retriever(fallback_year).errors
    context.fail!
  end

  def available?(retriever)
    retriever.success? && retriever.dictionary.present?
  end

  def retriever(year)
    @retrievers ||= {}
    @retrievers[year] ||= DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote.call(params: { year:, request_id:, user_id: })
  end

  def request_id
    context.params.fetch(:request_id)
  end

  def user_id
    context.params.fetch(:user_id)
  end
end
