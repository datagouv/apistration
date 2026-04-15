class PingService
  attr_reader :api_kind, :identifier

  def initialize(api_kind, identifier)
    @api_kind = api_kind.to_sym
    @identifier = identifier.to_sym
  end

  def perform
    return maintenance_response if maintenance?
    return cached_response if cached_response

    store_last_ok_status if status == :ok
    write_cache if cacheable?

    data
  end

  def self.config
    AppConfig.config_for(:pings)
  end

  private

  def data
    {
      status: http_status,
      json:
    }
  end

  def json
    return {} if status == :not_found

    {
      status:
    }.merge(common_payload_attributes)
  end

  def http_status
    case status
    when :ok, :unknown
      :ok
    when :not_found
      :not_found
    else
      :bad_gateway
    end
  end

  def status
    @status ||= Timeout.timeout(5) { ping_driver.new(ping_config.fetch(:driver_params)).perform }
  rescue KeyError
    :not_found
  rescue Timeout::Error
    :bad_gateway
  end

  def ping_driver
    Kernel.const_get("#{ping_config.fetch(:kind).classify}PingDriver")
  end

  def operation_id
    "ping_#{api_kind}_#{identifier}"
  end

  alias cache_key operation_id

  def cacheable?
    status == :ok && cache_enabled?
  end

  def write_cache
    cache.write(cache_key, data, expires_in: cache_expires_in)
  end

  def cached_response
    cache.read(cache_key)
  end

  def maintenance
    @maintenance ||= MaintenanceService.new(ping_config.fetch(:provider))
  end

  def maintenance?
    maintenance.on?
  rescue KeyError
    false
  end

  def maintenance_response
    {
      status: :ok,
      json: {
        status: :maintenance,
        until: Time.zone.now + maintenance.remaining_seconds
      }.merge(common_payload_attributes)
    }
  end

  def common_payload_attributes
    {
      last_update: current_time,
      last_ok_status:
    }
  end

  def last_ok_status
    redis_service.restore("last_ok_status_#{operation_id}") || current_time
  end

  def store_last_ok_status
    redis_service.dump("last_ok_status_#{operation_id}", current_time)
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

  def redis_service
    @redis_service ||= RedisService.new
  end

  def current_time
    @current_time ||= Time.zone.now
  end

  def ping_config
    pings_global_config.fetch(identifier)
  end

  def pings_global_config
    self.class.config[api_kind]
  end
end
