class DGFIP::Dictionaries::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! unless http_ok? && dictionary_in_body?
  end

  def dictionary_in_body?
    body.present? && json_body['dictionnaire'].present?
  end
end
