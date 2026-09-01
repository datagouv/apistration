class ProviderRawResponse
  def initialize(response)
    @response = response
  end

  def status
    raw_status&.to_i
  end

  def headers
    response.try(:headers) ||
      response.try(:each_header)&.to_h ||
      {}
  end

  def body
    response.try(:body).to_s
  end

  def body_base64
    Base64.strict_encode64(body)
  end

  def as_debugging_log
    {
      header: headers,
      body: body_base64,
      status:
    }
  end

  def as_meta
    {
      'status' => status,
      'headers' => headers,
      'body_base64' => body_base64
    }
  end

  private

  attr_reader :response

  def raw_status
    response.try(:status) || response.try(:code)
  end
end
