class MakeRequest < ApplicationInteractor
  class ResponseNotDefined < StandardError; end

  def self.inherited(klass)
    klass.class_eval do
      before do
        context.errors ||= []
      end

      after do
        if context.response.nil?
          response_not_defined!
        end
      end
    end
  end

  def call
    api_call
  rescue Net::OpenTimeout, Net::ReadTimeout, EOFError
    fail_to_request_provider!(
      ProviderTimeoutError,
    )
  rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EHOSTUNREACH
    fail_to_request_provider!(
      ProviderUnavailable,
    )
  rescue SocketError => e
    if dns_lookup_error?(e)
      fail_to_request_provider!(
        DnsResolutionError,
      )
    else
      raise
    end
  end

  protected

  def api_call
    fail NotImplementedError
  end

  def http_options
    {
      use_ssl:     true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER,
    }
  end

  def set_headers(request)
    request['Content-Type'] = 'application/json'
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
      'getaddrinfo: No address associated with hostname'
    ]
  end

  def response_not_defined!
    raise ResponseNotDefined
  end
end
