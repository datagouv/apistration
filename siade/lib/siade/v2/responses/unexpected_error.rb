class SIADE::V2::Responses::UnexpectedError < SIADE::V2::Responses::AbstractProviderError
  def error
    @error ||= ::ProviderUnknownError.new(provider_name)
  end

  def http_code
    502
  end

  def track_provider_error_from_response
    MonitoringService.instance.track(
      'error',
      error_message,
      error_context.merge(
        provider_name: provider_name,
      )
    )
  end

  def error_message
    exception_or_net_http_error.inspect
  end

  def error_context
    if exception?
      {
        exception_backtrace: exception_or_net_http_error.backtrace
      }
    else
      {
        net_http_error_status: exception_or_net_http_error.code,
        net_http_error_body: exception_or_net_http_error.body
      }
    end
  end

  def exception_or_net_http_error
    @exception
  end

  def exception?
    exception_or_net_http_error.is_a?(Exception)
  end
end
