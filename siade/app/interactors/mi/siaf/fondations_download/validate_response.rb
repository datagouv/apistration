class MI::SIAF::FondationsDownload::ValidateResponse < ValidateResponse
  ERROR_PAGE_TYPES = %w[text/html application/xhtml+xml application/xml].freeze

  declares_no_specific_errors!

  def call
    resource_not_found! if http_not_found?
    rate_limited! if http_too_many_requests?
    internal_server_error! if http_internal_error?

    unknown_provider_response! unless http_ok? && document?
  end

  private

  def document?
    body.present? && ERROR_PAGE_TYPES.exclude?(Marcel::MimeType.for(body)) && !json?
  end

  def json?
    JSON.parse(body)
    true
  rescue JSON::ParserError
    false
  end
end
