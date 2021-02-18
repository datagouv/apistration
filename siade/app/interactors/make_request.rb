class MakeRequest < ApplicationInteractor
  def call
    api_call
  rescue Net::OpenTimeout, Net::ReadTimeout, EOFError => e
    #FIXME
  rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EHOSTUNREACH => e
    #FIXME
  rescue SocketError => e
    if dns_lookup_errors_string.any? { |error_message| e.message.include?(error_message) }
      #FIXME
    else
      raise
    end
  end

  protected

  def request_uri
    fail 'should be implemented in inherited class'
  end

  def request_params
    fail 'should be implemented in inherited class'
  end

  def request_verb
    fail 'should be implemented in inherited class'
  end

  def http_options
    {}
  end

  private

  def api_call
    send("http_#{request_verb}_call")
  end

  def http_get_call
    context.response = Net::HTTP.start(request_uri.host, request_uri.port, http_options) do |http|
      request = Net::HTTP::Get.new(build_request)
      set_headers(request)
      http.read_timeout = 10
      http.open_timeout = 10
      http.request(request)
    end
  end

  def net_http_post_call
    context.response = Net::HTTP.start(request_uri.host, request_uri.port, net_http_options) do |http|
      request = Net::HTTP::Post.new(request_uri)
      set_headers(request)
      request.body = post_request_body
      http.read_timeout = 10
      http.open_timeout = 10
      http.request(request)
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
    !request_params.nil? && request_params.any?
  end

  def set_headers(request)
    request['Content-Type'] = 'application/json'
  end
end
