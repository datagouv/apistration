class AccessLogPingDriver < ApplicationPingDriver
  attr_reader :period, :routes

  def perform
    valid_access_logs.any? ? :ok : :bad_gateway
  end

  private

  def valid_access_logs
    AccessLog.where(
      route: routes,
      status: '200',
      timestamp: (beginning_of_period..)
    ).limit(1)
  end

  def beginning_of_period
    Time.zone.now - period
  end

  def build_context(driver_params)
    @period = driver_params.fetch(:period)
    @routes = driver_params.fetch(:routes)
  end
end
