class API::V3::BaseController < API::AuthenticateEntityController
  def render_errors(organizer)
    render json:    ::ErrorsSerializer.new(organizer.errors, format: error_format).as_json,
           status:  extract_http_code(organizer)
  end

  def extract_http_code(retriever)
    if at_least_one_error_kind_of?(:wrong_parameter, retriever)
      :unprocessable_entity
    elsif at_least_one_error_kind_of?(:network_error, retriever)
      :gateway_timeout
    elsif at_least_one_error_kind_of?(:unavailable_for_legal_reason, retriever)
      :unavailable_for_legal_reasons
    elsif at_least_one_error_kind_of?(:unauthorized, retriever)
      :unauthorized
    elsif at_least_one_error_kind_of?(:not_found, retriever)
      :not_found
    elsif at_least_one_error_kind_of?(:provider_error, retriever)
      :bad_gateway
    elsif retriever.errors.blank?
      :ok
    else
      raise 'No valid HTTP status'
    end
  end

  def at_least_one_error_kind_of?(kind, retriever)
    retriever.errors.any? do |error|
      error.kind == kind
    end
  end
end
