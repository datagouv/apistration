class MI::SIAF::Fondations::ValidateResponse < ValidateResponse
  declares_no_specific_errors!

  def call
    resource_not_found! if http_not_found?
    rate_limited! if http_too_many_requests?
    internal_server_error! if http_internal_error?

    unknown_provider_response! unless http_ok? && fondation?
  end

  private

  def fondation?
    JSON.parse(body, symbolize_names: true) in { id: String }
  rescue JSON::ParserError
    false
  end
end
