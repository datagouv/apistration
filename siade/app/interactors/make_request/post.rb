class MakeRequest::Post < MakeRequest
  protected

  def request_uri
    fail NotImplementedError
  end

  def request_params
    {}
  end

  def form_data
    {}
  end

  private

  def api_call
    context.response = http_wrapper do
      request = Net::HTTP::Post.new(request_uri)
      request.body = build_request_body
      request.set_form_data(form_data) if form_data.any?
      request
    end
  end

  def build_request_body
    request_params.to_json if request_params.any?
  end
end
