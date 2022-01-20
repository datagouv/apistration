class INPI::Actes::ValidateResponse < ValidateResponse
  def call
    invalid_provider_response! if invalid_json?

    resource_not_found! if payload_empty?

    return if http_ok?

    unknown_provider_response!
  end

  private

  def payload_empty?
    json_body.empty?
  end
end
