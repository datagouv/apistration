class CacheResourceCollectionRetriever < CacheResourceRetriever
  def wrap_retriever_data
    context.resource_collection = retrieved_context.resource_collection
    context.meta = retrieved_context.meta
  end

  def build_cache_data
    return unless retrieved_context.cacheable

    {
      resource_collection: retrieved_context.resource_collection,
      meta: retrieved_context.meta
    }
  end
end
