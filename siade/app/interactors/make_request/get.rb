class MakeRequest::Get < MakeRequest
  protected

  def request_uri
    fail 'should be implemented in inherited class'
  end

  def request_params
    fail 'should be implemented in inherited class'
  end

  private

  def api_call
    context.response = http_wrapper do
      Net::HTTP::Get.new(build_request)
    end
  end

  def build_request
    request_uri.tap do |req|
      req.query = encode_request_params if query_params?
    end
  end

  def encode_request_params
    URI.encode_www_form(request_params)
  end

  def query_params?
    !request_params.nil? &&
      request_params.any?
  end
end
