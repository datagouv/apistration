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
      provided_organizer_params:,
      response_body: JSON.parse(response.body),
      response_status: response.status
    )
  end

  def requests_debugging_enabled?
    RequestsDebuggingService.new(operation_id, response.status).enable?
  end

  def provided_organizer_params
    return organizer_params if respond_to?(:organizer_params)

    nil
  end
end
