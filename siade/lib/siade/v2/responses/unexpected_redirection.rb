class SIADE::V2::Responses::UnexpectedRedirection
  attr_reader :provider_name,
              :redirect_response

  def initialize(provider_name, redirect_response)
    @provider_name = provider_name
    @redirect_response = redirect_response

    track_wrong_redirect
  end

  def body
    ''
  end

  def http_code
    502
  end

  def errors
    [
      UnexpectedRedirectionError.new(provider_name, redirect_location),
    ]
  end

  def provider_error_custom_code
    http_code
  end

  private

  def track_wrong_redirect
    MonitoringService.instance.track_provider_error_from_response(
      self,
      {
        redirect_location: redirect_location,
      }
    )
  end

  def redirect_location
    redirect_response['location']
  end
end
