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
    errors.zero?
  end

  def rate_limit_threshold_crossed?
    rate_limited_errors.to_f / snapshot_total >= RATE_LIMIT_ERROR_RATIO_THRESHOLD
  end

  def error_limit_threshold_crossed?
    non_rate_limited_errors.to_f / snapshot_total >= ERROR_RATIO_THRESHOLD
  end

  def errors
    view_counts[1]
  end

  def view_counts
    @view_counts ||= counts || [0, 0]
  end

  def snapshot_total
    rate_limit_snapshot[0]
  end

  def rate_limited_errors
    rate_limit_snapshot[1]
  end

  def non_rate_limited_errors
    rate_limit_snapshot[2]
  end

  def rate_limit_snapshot
    @rate_limit_snapshot ||= AccessLog
      .where(route: routes, timestamp: 10.minutes.ago..)
      .pick(Arel.sql(<<~SQL.squish)) || [0, 0, 0]
        COUNT(*),
        COUNT(*) FILTER (WHERE status IN (#{quoted_error_statuses}) AND COALESCE(params ->> 'error_subcode', '') = '#{RATE_LIMIT_SUBCODE}'),
        COUNT(*) FILTER (WHERE status IN (#{quoted_error_statuses}) AND COALESCE(params ->> 'error_subcode', '') != '#{RATE_LIMIT_SUBCODE}')
      SQL
  end

  def quoted_error_statuses
    error_statuses.map { |s| "'#{s}'" }.join(', ')
  end
end
