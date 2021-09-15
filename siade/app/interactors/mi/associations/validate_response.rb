class MI::Associations::ValidateResponse < ValidateResponse
  def call
    return if http_ok? && payload_present?

    if http_not_found?
      resource_not_found!
    else
      invalid_provider_response!
    end
  end

  private

  def payload_present?
    xml_body_as_hash[:asso].present?
  rescue Ox::ParseError
    false
  end
end
