module ResourceHelpers
  def response
    context.response
  end

  def http_code
    response.code.to_i
  end

  def body
    response.body
  end

  def json_body
    context.json_body ||= JSON.parse(body)
  end
end
