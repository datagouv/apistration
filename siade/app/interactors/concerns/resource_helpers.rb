module ResourceHelpers
  delegate :response, to: :context

  def http_code
    response.code.to_i
  end

  def http_ok?
    http_code == 200
  end

  def http_bad_request?
    http_code == 400
  end

  def http_unauthorized?
    http_code == 401
  end

  def http_forbidden?
    http_code == 403
  end

  def http_not_found?
    http_code == 404
  end

  def http_conflict?
    http_code == 409
  end

  def http_unprocessable_entity?
    http_code == 422
  end

  def http_internal_error?
    http_code == 500
  end

  def http_provider_bad_gateway_error?
    http_code == 502
  end

  def http_too_many_requests?
    http_code == 429
  end

  def http_unavailable?
    http_code == 503
  end

  def http_provider_timeout_error?
    http_code == 504
  end

  delegate :body, to: :response

  def json_body
    context.json_body ||= JSON.parse(body)
  end

  def invalid_json?
    !valid_json?
  end

  def valid_json?
    json_body.present?
  rescue JSON::ParserError
    false
  end

  def xml_body_as_hash
    context.xml_body_as_hash ||= Ox.load(body.force_encoding('UTF-8'), mode: :hash)
  end

  def normalized_date(date)
    return unless date

    date.to_time.strftime('%Y-%m-%d')
  end
end
