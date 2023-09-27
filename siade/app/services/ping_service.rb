class PingService
  attr_reader :api_kind, :identifier

  def initialize(api_kind, identifier)
    @api_kind = api_kind.to_sym
    @identifier = identifier.to_sym
  end

  def perform
    return cached_response if cached_response

    write_cache if cacheable?

    data
  end

  private

  def data
    {
      status:,
      json:
    }
  end

  def json
    return {} if status == :not_found

    {
      last_update: Time.zone.now
    }
  end

  def status
    if success?
      :ok
    else
      :bad_gateway
    end
  rescue KeyError
    :not_found
  end

  def success?
    @success ||= retriever.call(params: retriever_params, operation_id:).success?
  end

  def retriever
    Kernel.const_get(ping_config.fetch(:retriever))
  end

  def retriever_params
    ping_config.fetch(:params, {}).transform_keys(&:to_sym)
  end

  def operation_id
    "ping_#{api_kind}_#{identifier}"
  end

  alias :cache_key :operation_id

  def cacheable?
    status == :ok && cache_enabled?
  end

  def write_cache
    cache.write(cache_key, data, expires_in: cache_expires_in)
  end

  def cached_response
    cache.read(cache_key)
  end

  def cache_expires_in
    ping_config.fetch(:cache)
  end

  def cache_enabled?
    ping_config.fetch(:cache, nil).present?
  end

  def cache
    Rails.cache
  end

  def ping_config
    pings_global_config.fetch(identifier)
  end

  def pings_global_config
    Rails.application.config_for(:pings)[api_kind]
  end
end
