class MakeRequest::Post < MakeRequest
  protected

  def request_uri
    fail 'should be implemented in inherited class'
  end

  def http_options
    {}
  end

  def api_call
    context.response = http_wrapper do
      request = Net::HTTP::Post.new(request_uri)
      request.body = post_request_body
      request
    end
  end
end
