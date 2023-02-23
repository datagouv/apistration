module CanLogRequestsInfoForDebugging
  extend ActiveSupport::Concern

  included do
    after_action :log_request_info_for_debugging, if: :requests_debugging_enabled?
  end

  def log_request_info_for_debugging
    RequestsDebuggerLogger.instance.log(
      controller_name:,
      path: request.path,
      request_params: request.params.except('token', 'controller', 'action'),
      response_body: JSON.parse(response.body),
      response_status: response.status
    )
  end

  def requests_debugging_enabled?
    requests_debugging_config['enable'] &&
      requests_debugging_config['operation_ids'].include?(operation_id)
  end

  def requests_debugging_config
    @requests_debugging_config ||= Rails.configuration.requests_debugging
  end
end
