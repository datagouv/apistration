class DGFIP::Dictionaries::ValidateResponse < ValidateResponse
  declares_no_specific_errors!

  def call
    unknown_provider_response! unless http_ok? && dictionary_in_body?
  end

  def dictionary_in_body?
    body.present? && !invalid_json? && json_body['dictionnaire'].present?
  end
end
