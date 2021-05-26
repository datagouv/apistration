class SIADE::V2::Responses::Generic
  attr_accessor :raw_response,
    :http_code,
    :body,
    :provider_error_context

  # No explicit call, initialize is enough
  def initialize(raw_response)
    @raw_response = raw_response
    @provider_error_context = {}
    @body = raw_response.body
    @http_code = adapt_raw_response_code

    track_provider_error_from_response if provider_error?
  end

  def provider_error_custom_code
    @provider_error_custom_code || @http_code
  end

  def errors
    @errors ||= []
  end

  protected

  def provider_name
    fail 'implement me in subclass'
  end

  def adapt_raw_response_code
    fail 'implement me in subclass'
  end

  def add_context_to_provider_error_tracking(context)
    @provider_error_context.merge!(context)
  end

  def set_error_message_for(status)
    self.send("set_error_message_#{status}")
    @http_code = status
  end

  private

  def internal_error?
    @raw_response.code == '500'
  end

  def provider_error?
    (500..599).include?(http_code.to_i)
  end

  def set_error_message_404
    errors << NotFoundError.new(provider_name)
  end

  def set_error_message_502
    errors << ProviderInternalServerError.new(provider_name)
  end

  def track_provider_error_from_response
    MonitoringService.instance.track_provider_error_from_response(
      self,
      provider_error_context,
    )
  end
end
