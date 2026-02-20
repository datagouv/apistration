class MakeRequest::Get < MakeRequest
  protected

  def request_uri
    fail NotImplementedError
  end

  def request_params
    fail NotImplementedError
  end

  def request_body
    nil
  end

  private

  def api_call
    uri = build_request
    context.request_url = uri.to_s

    context.response = http_wrapper do
      Net::HTTP::Get.new(uri).tap do |req|
        req.body = request_body
      end
    end
  end

  def build_request
    request_uri.tap do |uri|
      uri.query = encode_request_params if query_params?
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
