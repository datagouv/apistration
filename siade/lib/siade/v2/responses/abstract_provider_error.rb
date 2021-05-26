class SIADE::V2::Responses::AbstractProviderError
  attr_reader :provider_name,
              :exception

  def initialize(provider_name, exception=nil)
    @provider_name = provider_name
    @exception = exception

    track_provider_error_from_response
  end

  def body
    ''
  end

  def error
    fail 'should implement error'
  end

  def http_code
    fail 'should implement http_code'
  end

  def errors
    [error]
  end

  def provider_error_custom_code
    http_code
  end

  private

  def track_provider_error_from_response
    MonitoringService.instance.track_provider_error_from_response(
      self,
      exception_context,
    )
  end

  def exception_context
    if exception
      {
        exception_inspect:   exception.inspect,
        exception_backtrace: exception.backtrace,
      }
    end
  end
end
