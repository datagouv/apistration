class RateLimitHeadersMiddleware
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    throttle_raw_data = env['rack.attack.throttle_data']
    return app.call(env) if throttle_raw_data.nil?

    data = extract_throttle_data(throttle_raw_data)
    return app.call(env) if data.nil?

    status, headers, body = app.call(env)

    build_rate_limit_headers(data).each do |key, value|
      headers[key] = value
    end

    [status, headers, body]
  end

  def build_rate_limit_headers(data)
    RateLimitingService.new.build_rate_limit_headers(data)
  end

  private

  def extract_throttle_data(throttle_raw_data)
    if throttle_raw_data.key?('custom_rate_limit')
      throttle_raw_data['custom_rate_limit']
    elsif throttle_raw_data.many?
      log_multiple_throttle(throttle_raw_data)
      nil
    else
      throttle_raw_data.values[0]
    end
  end

  def log_multiple_throttle(throttle_raw_data)
    MonitoringService.instance.track_with_added_context(
      'warning',
      'Multiple throttle data detected (Rack::Attack misconfiguration)',
      throttle_raw_data
    )
  end
end
