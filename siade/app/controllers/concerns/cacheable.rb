module Cacheable
  extend ActiveSupport::Concern

  included do
    attr_reader :cached_retriever

    before_action :init_x_response_cached_header
  end

  def retrieve_payload_data(retriever, cache: false, expires_in: nil, cache_key: nil)
    if cache && !bypass_cache?
      @cached_retriever = CacheResourceRetriever.call(
        retriever_organizer: retriever,
        retriever_params: organizer_params,
        cache_key:,
        expires_in:
      )

      mark_response_as_cached_in_response!

      @cached_retriever
    else
      retriever.call(params: organizer_params)
    end
  end

  def bypass_cache?
    request.headers['Cache-Control'] == 'no-cache'
  end

  def mark_response_as_cached_in_response!
    response.headers['X-Response-Cached'] = @cached_retriever.from_cache
  end

  def init_x_response_cached_header
    response.headers['X-Response-Cached'] = false
  end
end
