class INPI::Marques::ValidateResponse < INPI::ValidateResponse
  def call
    unknown_provider_response! if invalid_json?

    resource_not_found! unless payload_has_results?

    return if http_ok? && payload_has_valid_results? && payload_has_required_fields?

    unknown_provider_response!
  end

  private

  def payload_has_required_fields?
    results_have_document_id? &&
      results_have_application_number_field?
  end

  def results_have_document_id?
    json_body['results'].all? { |item| item['documentId'].present? }
  end

  def results_have_application_number_field?
    json_body['results'].all? { |result| result['fields'].any? { |field| field.value?('ApplicationNumber') } }
  end
end
