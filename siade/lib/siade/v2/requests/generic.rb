class SIADE::V2::Requests::Generic
  include ActiveModel::Model
  include SIADE::V2::Utilities::UnprocessableEntityHelpers

  attr_reader :raw_response, :response

  def valid?
    fail 'should implement valid?, it s checked in generic driver'
  end

  def http_code
    @http_code || response.http_code
  end

  def errors
    @errors || response.errors
  end

  def body
    @response.body
  end

  def perform
    set_monitoring_context

    valid? && call_api

    self
  end

  protected

  def provider_name
    fail 'should implement provider_name'
  end

  def request_uri
    fail 'should implement request_uri'
  end

  def request_params
    fail 'should implement request_params'
  end

  def request_lib
    fail 'should implement request_lib, possible values: :rest_client, :net_http'
  end

  def request_verb
    fail 'should implement request_verb, possible values: :get, :post'
  end

  def response_wrapper
    fail 'should implement response_wrapper'
  end

  def post_request_body
    fail 'should implement post_request_body'
  end

  def net_http_options
    fail 'should implement net_http_options'
  end

  def follow_redirect(redirect_response)
    SIADE::V2::Responses::UnexpectedRedirection.new(provider_name, redirect_response)
  end

  def rest_client_options
    {}
  end

  def default_rest_client_options
    {
      open_timeout: 10,
      read_timeout: 10
    }
  end

  def all_rest_client_options
    rest_client_options.merge(default_rest_client_options)
  end

  def set_headers(request)
    request['Content-Type'] = 'application/json'
  end

  def encode_request_params
    URI.encode_www_form(request_params)
  end

  def call_api
    try_call_api
  rescue Net::OpenTimeout, Net::ReadTimeout, EOFError => e
    @response = SIADE::V2::Responses::TimeoutError.new(provider_name, e)
  rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EHOSTUNREACH => e
    @response = SIADE::V2::Responses::ServiceUnavailable.new(provider_name, e)
  rescue Errno::ENETUNREACH => e
    @response = SIADE::V2::Responses::NetworkError.new(provider_name, e)
  rescue SocketError => e
    if dns_lookup_errors_string.any? { |error_message| e.message.include?(error_message) }
      @response = SIADE::V2::Responses::DnsResolutionError.new(provider_name)
    else
      raise
    end
  rescue OpenSSL::SSL::SSLError => e
    if e.message.include?('SSLv3/TLS write client hello')
      @response = SIADE::V2::Responses::UnexpectedError.new(provider_name, e)
    else
      raise
    end
  end

  def try_call_api
    send("#{request_lib}_#{request_verb}_call")
  end

  def net_http_get_call
    PerformanceMonitoringService.instance.track(op: :net_http_all, description: 'whole get call + TLS stuff') do
      @raw_response = Net::HTTP.start(request_uri.host, request_uri.port, net_http_options.merge(timeout_http_options)) do |http|
        request = Net::HTTP::Get.new(build_request)
        set_headers(request)
        http.request(request)
      end

      @response = build_response
    end
  end

  def net_http_post_call
    @raw_response = Net::HTTP.start(request_uri.host, request_uri.port, net_http_options.merge(timeout_http_options)) do |http|
      request = Net::HTTP::Post.new(request_uri)
      set_headers(request)
      request.body = post_request_body
      http.request(request)
    end

    @response = build_response
  end

  def timeout_http_options
    {
      open_timeout: 10,
      read_timeout: 10,
    }
  end

  def build_request
    request_uri.tap do |req|
      req.query = encode_request_params if query_params?
    end
  end

  def query_params?
    !request_params.nil? && request_params.any?
  end

  def rest_client_get_call
    rest_call_with_rescue_routine do
      @raw_response = RestClient::Resource.new(request_uri.to_s, all_rest_client_options)
        .get(params: request_params)

      @response = response_wrapper.new(raw_response)
    end
  end

  def rest_client_post_call
    rest_call_with_rescue_routine do
      @raw_response = RestClient::Resource.new(request_uri.to_s, all_rest_client_options)
        .post(request_params)

      @response = response_wrapper.new(raw_response)
    end
  end

  def rest_call_with_rescue_routine
    yield
  rescue RestClient::ResourceNotFound
    @response = SIADE::V2::Responses::ResourceNotFound.new(provider_name)
  rescue RestClient::InternalServerError, RestClient::ServerBrokeConnection => e
    @response = SIADE::V2::Responses::InternalServerError.new(provider_name, e)
  rescue RestClient::RequestTimeout => e
    @response = SIADE::V2::Responses::TimeoutError.new(provider_name, e)
  rescue RestClient::ServiceUnavailable
    @response = SIADE::V2::Responses::ServiceUnavailable.new(provider_name, e)
  rescue RestClient::Forbidden, RestClient::Exception => e
    @response = SIADE::V2::Responses::UnexpectedError.new(provider_name, e)
  end

  def set_error_message_for(status)
    send("set_error_message_#{status}")
    @http_code = status
  end

  private

  def set_monitoring_context
    MonitoringService.instance.set_provider(provider_name)
  end

  def build_response
    case @raw_response
    when Net::HTTPOK
      response_wrapper.new(raw_response)
    when Net::HTTPNotFound
      SIADE::V2::Responses::ResourceNotFound.new(provider_name)
    when Net::HTTPInternalServerError
      SIADE::V2::Responses::InternalServerError.new(provider_name)
    when Net::HTTPBadRequest
      SIADE::V2::Responses::UnexpectedBadRequest.new(provider_name)
    when Net::HTTPGatewayTimeout
      SIADE::V2::Responses::TimeoutError.new(provider_name)
    when Net::HTTPServiceUnavailable, Net::HTTPBadGateway, Net::HTTPTooManyRequests
      SIADE::V2::Responses::ServiceUnavailable.new(provider_name)
    when Net::HTTPMovedPermanently, Net::HTTPMovedTemporarily
      follow_redirect(@raw_response)
    else
      SIADE::V2::Responses::UnexpectedError.new(provider_name, @raw_response)
    end
  end

  def dns_lookup_errors_string
    [
      'getaddrinfo: nodename nor servname provided, or not known',
      'getaddrinfo: No address associated with hostname',
      'getaddrinfo: Name or service not known',
      'getaddrinfo: Temporary failure in name resolution'
    ]
  end
end
