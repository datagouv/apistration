module ResourceHelpers
  delegate :response, to: :context

  def http_code
    response.code.to_i
  end

  delegate :body, to: :response

  def json_body
    context.json_body ||= JSON.parse(body)
  end
end
