class RequestsDebuggingService
  def initialize(operation_id, status)
    @operation_id = operation_id
    @status = status
  end

  def enable?
    before_enable_until? &&
      operation_id_in_list? &&
      status_valid?
  end

  private

  def before_enable_until?
    Time.zone.today <= enable_until
  end

  def operation_id_in_list?
    requests_debugging_config['operation_ids'].include?(@operation_id)
  end

  def status_valid?
    valid_http_status.include?(@status)
  end

  def enable_until
    @enable_until ||= Date.parse(requests_debugging_config['enable_until'])
  end

  def valid_http_status
    [
      200,
      404,
      500,
      502,
      503,
      504
    ]
  end

  def requests_debugging_config
    @requests_debugging_config ||= Rails.configuration.requests_debugging
  end
end
