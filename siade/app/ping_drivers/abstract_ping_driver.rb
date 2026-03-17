class AbstractPingDriver < ApplicationPingDriver
  ERROR_RATIO_THRESHOLD = 0.1

  attr_reader :routes

  def perform
    return :bad_gateway unless health_check_ok?
    return :ok if recently_out_of_maintenance?
    return :bad_gateway if error_ratio_too_high?

    :ok
  end

  private

  def health_check_ok?
    true
  end

  def provider
    raise NotImplementedError
  end

  def error_statuses
    %w[503 504]
  end

  def recently_out_of_maintenance?
    maintenance = MaintenanceService.new(provider)
    end_time = maintenance.to_hour
    now = Time.zone.now

    now >= end_time && now < end_time + 10.minutes
  rescue StandardError
    false
  end

  def error_ratio_too_high?
    total, errors = AccessLogPingView
      .where(route: routes)
      .pick(Arel.sql("COUNT(*), COUNT(*) FILTER (WHERE status IN (#{error_statuses.map { |s| "'#{s}'" }.join(', ')}))"))

    return false if total.nil? || total.zero?

    errors.to_f / total >= ERROR_RATIO_THRESHOLD
  end
end
