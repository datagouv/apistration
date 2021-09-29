class MakeRequest < ApplicationInteractor
  class ResponseNotDefined < StandardError; end

  def self.inherited(klass)
    klass.class_eval do
      before do
        context.errors ||= []
      end

      after do
        response_not_defined! if context.response.nil?
      end
    end
  end

  def call
    api_call

    handle_redirect if response_is_a_redirection?
  rescue Net::OpenTimeout, Net::ReadTimeout, EOFError
    fail_to_request_provider!(ProviderTimeoutError)
  rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EHOSTUNREACH
    fail_to_request_provider!(ProviderUnavailable)
  rescue Errno::ENETUNREACH
    context.errors << NetworkError.new
    context.fail!
  rescue SocketError => e
    raise unless dns_lookup_error?(e)

    fail_to_request_provider!(DnsResolutionError)
  end

  protected

  def api_call
    fail NotImplementedError
  end

  def http_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER
    }
  end

  def set_headers(request)
    request['Content-Type'] = 'application/json'
  end

  def handle_redirect
    context.errors << UnexpectedRedirectionError.new(context.provider_name, context.response)
    context.fail!
  end

  private

  def http_wrapper(&block)
    Net::HTTP.start(request_uri.host, request_uri.port, http_options) do |http|
      request = block.call

      set_headers(request)
      http.read_timeout = 10
      http.open_timeout = 10
      http.request(request)
    end
  end

  def fail_to_request_provider!(provider_klass_error)
    context.errors << provider_klass_error.new(context.provider_name)
    context.fail!
  end

  def dns_lookup_error?(exception)
    dns_lookup_errors_string.any? do |error_message|
      exception.message.include?(error_message)
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

  def response_is_a_redirection?
    context.response.present? &&
      %w[
        301
        302
        303
        307
        308
      ].include?(context.response.code)
  end

  def response_not_defined!
    raise ResponseNotDefined
  end
end
