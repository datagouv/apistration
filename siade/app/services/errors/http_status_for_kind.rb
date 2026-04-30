class Errors::HTTPStatusForKind
  KIND_TO_STATUS = {
    wrong_parameter: :unprocessable_content,
    network_error: :bad_gateway,
    provider_error: :bad_gateway,
    provider_unknown_error: :bad_gateway,
    timeout_error: :gateway_timeout,
    unavailable_for_legal_reason: :unavailable_for_legal_reasons,
    unauthorized: :unauthorized,
    not_found: :not_found,
    conflict: :conflict,
    internal_error: :internal_error,
    too_many_requests: :too_many_requests,
    maintenance: :service_unavailable
  }.freeze

  def self.call(kind)
    KIND_TO_STATUS[kind]
  end
end
