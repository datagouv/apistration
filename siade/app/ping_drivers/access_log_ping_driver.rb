class AccessLogPingDriver < ApplicationPingDriver
  attr_reader :period, :routes

  def perform
    if relevant_access_logs_statuses.include?('200')
      :ok
    elsif relevant_access_logs_statuses.any?
      :bad_gateway
    else
      :unknown
    end
  end

  private

  def relevant_access_logs_statuses
    @relevant_access_logs_statuses ||= AccessLog.where(
      route: routes,
      timestamp: (beginning_of_period..)
    ).where.not(
      status: %w[401 403 422]
    ).pluck(:status)
  end

  def beginning_of_period
    Time.zone.now - period
  end

  def build_context(driver_params)
    @period = driver_params.fetch(:period)
    @routes = driver_params.fetch(:routes)
  end
end
