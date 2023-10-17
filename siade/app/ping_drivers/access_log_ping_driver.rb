class AccessLogPingDriver < ApplicationPingDriver
  attr_reader :period, :routes, :excluded_statuses

  def perform
    if latest_authenticated_and_valid_params_logs_statuses.include?('200')
      :ok
    elsif latest_authenticated_and_valid_params_logs_statuses.any?
      :bad_gateway
    else
      :unknown
    end
  end

  private

  def latest_authenticated_and_valid_params_logs_statuses
    @latest_authenticated_and_valid_params_logs_statuses ||= AccessLog.where(
      route: routes,
      timestamp: (beginning_of_period..)
    ).where.not(
      status: %w[401 403 422].concat(excluded_statuses)
    ).pluck(:status)
  end

  def beginning_of_period
    Time.zone.now - period
  end

  def build_context(driver_params)
    @period = driver_params.fetch(:period)
    @routes = driver_params.fetch(:routes)
    @excluded_statuses = driver_params.fetch(:excluded_statuses, []).map(&:to_s)
  end
end
