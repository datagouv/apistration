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
      .pick(
        Arel.star.count,
        errors_count_where(error_subcode.is_not_distinct_from(RATE_LIMIT_SUBCODE)),
        errors_count_where(error_subcode.is_distinct_from(RATE_LIMIT_SUBCODE))
      ) || [0, 0, 0]
  end

  def errors_count_where(subcode_condition)
    Arel.star.count.filter(error_status_in(AccessLog).and(subcode_condition))
  end

  def error_subcode
    Arel::Nodes::InfixOperation.new('->>', AccessLog.arel_table[:params], Arel::Nodes.build_quoted('error_subcode'))
  end
end
