module ResourceHelpers
  delegate :response, to: :context

  def http_code
    response.code.to_i
  end

  delegate :body, to: :response

  def json_body
    context.json_body ||= JSON.parse(body)
  end

  def xml_body_as_hash
    context.xml_body_as_hash ||= Ox.load(body.force_encoding('UTF-8'), mode: :hash)
  end
end
