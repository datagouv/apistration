class BuildResource < ApplicationInteractor
  def response
    context.response
  end

  def body
    response.body
  end

  def json_body
    context.json_body ||= JSON.parse(body)
  end
end
