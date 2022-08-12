module Cacheable
  extend ActiveSupport::Concern

  included do
    attr_reader :cached_retriever
  end

  def retrieve_payload_data(retriever, cache: false, expires_in: nil, cache_key: nil)
    if cache && !bypass_cache?
      @cached_retriever = CacheResourceRetriever.call(
        retriever_organizer: retriever,
        retriever_params: organizer_params,
        cache_key:,
        expires_in:
      )
    else
      retriever.call(organizer_params)
    end
  end

  def bypass_cache?
    request.headers['Cache-Control'] == 'no-cache'
  end
end
