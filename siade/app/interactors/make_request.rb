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

  def api_call
    fail 'should be implemented in inherited class'
  end

  def http_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER,
    }
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

  def set_headers(request)
    request['Content-Type'] = 'application/json'
  end
end
