class MakeRequest < ApplicationInteractor
  include HostMethodsHelpers

  class ResponseNotDefined < StandardError; end

  def self.inherited(klass)
    klass.class_eval do
      before do
        context.errors ||= []
      end
    end
  end

  def call
    if use_mocked_data?
      mock_call
      track_mock_operation
    else
      api_call_with_error_handling
    end
  end

  protected

  def mock_call
    context.mocked_data = MockService.new(operation_id, mocked_params).mock
  end

  def operation_id
    context.operation_id
  end

  def mocked_params
    api_particulier_v2? ? mocking_params_v2 : mocking_params
  end

  def mocking_params_v2
    context.params
  end

  def mocking_params
    mocked_params = context.params.dup
    mocked_params.delete(:recipient)

    mocked_params
  end

  def api_particulier_v2?
    operation_id.include?('api_particulier_v2')
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def api_call_with_error_handling
    response = api_call

    handle_potential_soft_errors

    handle_redirect if response_is_a_redirection?

    response
  rescue Net::OpenTimeout, Net::ReadTimeout, EOFError
    fail_to_request_provider!(ProviderTimeoutError)
  rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EHOSTUNREACH
    fail_to_request_provider!(ProviderUnavailable)
  rescue Errno::ENETUNREACH
    context.errors << NetworkError.new
    context.fail!
  rescue OpenSSL::SSL::SSLError => e
    context.http_retry_count ||= 0

    if open_ssl_network_error?(e)
      context.errors << NetworkError.new
      context.fail!
    elsif open_ssl_certificate_error?(e)
      fail_to_request_provider!(SSLCertificateError)
    elsif open_ssl_temporary_error?(e) && context.http_retry_count < 2
      context.http_retry_count += 1

      retry
    else
      raise
    end
  rescue SocketError => e
    raise unless dns_lookup_error?(e)

    fail_to_request_provider!(DnsResolutionError)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def api_call
    fail NotImplementedError
  end

  def http_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER
    }
  end

  def extra_headers(request)
    request['Content-Type'] = 'application/json' if request['Content-Type'].nil?
  end

  def handle_redirect
    context.errors << UnexpectedRedirectionError.new(context.provider_name, context.response)
    context.fail!
  end

  def extra_http_start_options
    {
      open_timeout: 10,
      read_timeout: 10
    }
  end

  private

  def http_wrapper(&block)
    Net::HTTP.start(request_uri.host, request_uri.port, http_options.merge(extra_http_start_options)) do |http|
      request = block.call

      extra_headers(request)
      http.request(request)
    end
  end

  def track_mock_operation
    mocked_operation_ok = context.mocked_data.present? ? 'OK' : 'NOK'

    MonitoringService.instance.track('debug', "## Mocking operation #{operation_id} with params #{mocked_params} : #{mocked_operation_ok}")
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
      'nodename nor servname provided, or not known',
      'No address associated with hostname',
      'Name or service not known',
      'Temporary failure in name resolution'
    ]
  end

  def handle_potential_soft_errors
    error = net_http_response_class_to_error[context.response.class]

    return if error.blank?

    fail_to_request_provider!(error)
  end

  def net_http_response_class_to_error
    {
      Net::HTTPServiceUnavailable => ProviderUnavailable,
      Net::HTTPGatewayTimeout => ProviderTimeoutError,
      Net::HTTPBadGateway => ProviderUnavailable
    }
  end

  def open_ssl_network_error?(exception)
    [
      'SSLv3/TLS write client hello'
    ].any? do |error_message|
      exception.message.include?(error_message)
    end
  end

  def open_ssl_certificate_error?(exception)
    exception.message.include?('certificate verify failed')
  end

  def open_ssl_temporary_error?(exception)
    [
      'unexpected eof while reading'
    ].any? do |error_message|
      exception.message.include?(error_message)
    end
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
end
