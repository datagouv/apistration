class DGFIP::LiassesFiscales::RetrieveDictionariesFromCacheOrRemote < DGFIP::LiassesFiscales::RetrieveDictionariesWithFallback
  delegates_to DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote

  def call
    context.default_dictionary_key = requested_year

    super
  end

  protected

  def years_with_fallback_by_key
    declarations
      .map { |declaration| DGFIP::LiassesFiscales::EnrichResourceWithDictionary.dictionary_key(declaration, requested_year) }
      .uniq
      .index_with { |year| [year, requested_year] }
  end

  private

  def declarations
    context.bundled_data.data.declarations
  end

  def requested_year
    context.params.fetch(:year).to_s
  end
end
