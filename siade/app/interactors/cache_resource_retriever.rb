class CacheResourceRetriever < ApplicationInteractor
  DEFAULT_EXPIRATION_TIME = 1.hour

  before do
    context.errors ||= []
    context.from_cache = false
  end

  def call
    retrieve_from_cache! ||
      call_and_cache

    context.fail! if context.errors.any?
  end

  private

  def cache_key
    context.cache_key || build_cache_key
  end

  def build_cache_key
    "#{retriever_organizer.to_s.tableize}:#{retriever_params.fetch(:params).to_query}"
  end

  def cache_expiration_in_seconds
    context.expires_in || DEFAULT_EXPIRATION_TIME
  end

  def retriever_organizer
    context.retriever_organizer || fail(ArgumentError)
  end

  def retriever_params
    context.retriever_params || fail(ArgumentError)
  end

  def retrieve_from_cache!
    return unless (context.cached_data = EncryptedCache.read(cache_key))

    context.from_cache = true
    context.expires_in = EncryptedCache.expires_in(cache_key)

    wrap_cache_data_in_context!
  end

  def wrap_cache_data_in_context!
    context.cached_data.each do |k, v|
      context.public_send("#{k}=", v)
    end
  end

  def call_and_cache
    context.retriever = retriever_organizer.call(context.retriever_params)

    wrap_retriever
    cache_retriever
  end

  def wrap_retriever
    if retrieved_context.success?
      wrap_retriever_data
    else
      wrap_retriever_errors
    end
  end

  def wrap_retriever_data
    context.bundled_data = retrieved_context.bundled_data
  end

  def wrap_retriever_errors
    context.errors = retrieved_context.errors
  end

  def cache_retriever
    cache_data = if retrieved_context.success?
                   build_cache_data
                 else
                   build_cache_errors
                 end

    write_into_cache(cache_data) if cache_data
  end

  def build_cache_data
    return unless retrieved_context.cacheable

    {
      bundled_data: retrieved_context.bundled_data
    }
  end

  def build_cache_errors
    return unless cache_errors?

    { errors: retrieved_context.errors }
  end

  def cache_errors?
    retrieved_context.errors.any? &&
      retrieved_context.cacheable &&
      !excluded_errors?
  end

  def write_into_cache(val)
    EncryptedCache.write(cache_key, val, expires_in: cache_expiration_in_seconds)
  end

  def retrieved_context
    context.retriever
  end

  def excluded_errors?
    [
      ProviderUnavailable,
      NetworkError,
      ForbiddenError,
      MaintenanceError,
      NotImplementedError
    ].any? { |error| retrieved_context.errors.any?(error) }
  end
end
