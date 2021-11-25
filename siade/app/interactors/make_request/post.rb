class MakeRequest::Post < MakeRequest
  protected

  def request_uri
    fail NotImplementedError
  end

  def request_params
    {}
  end

  private

  def api_call
    context.response = http_wrapper do
      request = Net::HTTP::Post.new(request_uri)
      request.body = build_request_body
      request
    end
  end

  def build_request_body
    request_params.to_json
  end
end
