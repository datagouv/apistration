class AccessLogPingDriver < ApplicationPingDriver
  attr_reader :routes, :excluded_statuses

  def perform
    if latest_authenticated_and_valid_params_logs_statuses.include?('200')
      :ok
    elsif latest_authenticated_and_valid_params_logs_statuses.any?
      :bad_gateway
    else
      :unknown
    end
  rescue ActiveRecord::StatementInvalid => e
    case e.cause
    when PG::UndefinedTable
      :unknown
    else
      raise
    end
  end

  private

  def latest_authenticated_and_valid_params_logs_statuses
    @latest_authenticated_and_valid_params_logs_statuses ||= AccessLogPingView.where(
      route: routes
    ).where.not(
      status: %w[401 403 422].concat(excluded_statuses)
    ).pluck(:status)
  end

  def build_context(driver_params)
    @routes = driver_params.fetch(:routes)
    @excluded_statuses = driver_params.fetch(:excluded_statuses, []).map(&:to_s)
  end
end
