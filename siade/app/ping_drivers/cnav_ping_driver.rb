class CNAVPingDriver < AbstractPingDriver
  RATE_LIMIT_ERROR_RATIO_THRESHOLD = 0.25
  RATE_LIMIT_SUBCODE = '008'.freeze

  private

  attr_reader :provider

  def error_statuses
    %w[502 503 504]
  end

  def build_context(driver_params)
    @routes = driver_params.fetch(:routes)
    @provider = driver_params.fetch(:provider)
  end

  def error_ratio_too_high?
    return false if no_errors?

    return true if rate_limit_threshold_crossed?

    error_limit_threshold_crossed?
  end

  def no_errors?
    total.nil? || total.zero? || errors.zero?
  end

  def rate_limit_threshold_crossed?
    rate_limited_errors.to_f / total >= RATE_LIMIT_ERROR_RATIO_THRESHOLD
  end

  def error_limit_threshold_crossed?
    [errors - rate_limited_errors, 0].max.to_f / total >= ERROR_RATIO_THRESHOLD
  end

  def total
    counts[0]
  end

  def errors
    counts[1]
  end

  def counts
    @counts ||= super || [0, 0]
  end

  def rate_limited_errors
    @rate_limited_errors ||= AccessLog
      .where(route: routes, status: error_statuses, timestamp: 10.minutes.ago..)
      .where("params ->> 'error_subcode' = ?", RATE_LIMIT_SUBCODE)
      .count
  end
end
