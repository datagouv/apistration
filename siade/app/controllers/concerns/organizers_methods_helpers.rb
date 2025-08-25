module OrganizersMethodsHelpers
  # rubocop:disable Metrics
  def extract_http_code(retriever)
    return retriever.mocked_data[:status] if retriever.mocked_data

    if retriever.errors.blank?
      :ok
    elsif at_least_one_error_kind_of?(:wrong_parameter, retriever)
      :unprocessable_content
    elsif at_least_one_error_kind_of?(%i[network_error provider_error provider_unknown_error], retriever)
      :bad_gateway
    elsif at_least_one_error_kind_of?(:timeout_error, retriever)
      :gateway_timeout
    elsif at_least_one_error_kind_of?(:unavailable_for_legal_reason, retriever)
      :unavailable_for_legal_reasons
    elsif at_least_one_error_kind_of?(:unauthorized, retriever)
      :unauthorized
    elsif at_least_one_error_kind_of?(:not_found, retriever)
      :not_found
    elsif at_least_one_error_kind_of?(:conflict, retriever)
      :conflict
    elsif at_least_one_error_kind_of?(:internal_error, retriever)
      :internal_error
    elsif at_least_one_error_kind_of?(:too_many_requests, retriever)
      :too_many_requests
    elsif at_least_one_error_kind_of?(:maintenance, retriever)
      :service_unavailable
    else
      raise 'No valid HTTP status'
    end
  end
  # rubocop:enable Metrics
end
