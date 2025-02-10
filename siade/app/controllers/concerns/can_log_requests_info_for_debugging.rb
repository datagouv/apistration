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
      provider: provider_payload,
      response_body: JSON.parse(response.body),
      response_status: response.status
    )
  end

  def provider_payload
    return {} unless organizer.response

    {
      header: organizer.response.try(:headers) || {},
      body: Base64.strict_encode64(organizer.response.try(:body) || ''),
      status: organizer.response.try(:status) || ''
    }
  end

  def requests_debugging_enabled?
    RequestsDebuggingService.new(operation_id, response.status).enable?
  end

  def provided_organizer_params
    return organizer_params if respond_to?(:organizer_params)

    nil
  end
end
