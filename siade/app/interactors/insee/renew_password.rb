class INSEE::RenewPassword < MakeRequest::Post
  def call
    super

    fail_with_authentication_error! unless renewal_accepted?
  end

  protected

  def request_uri
    URI("#{base_uri}/#{sirene_base_path}/renouvellement")
  end

  def request_params
    {
      oldPassword: context.old_password,
      newPassword: context.new_password
    }
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{context.token}"
    super
  end

  def base_uri
    Siade.credentials[:insee_sirene_url]
  end

  def sirene_base_path
    'api-sirene/prive/3.11'
  end

  private

  def renewal_accepted?
    context.response&.code&.to_i == 200
  end

  def fail_with_authentication_error!
    track_renewal_rejected!

    context.errors << ProviderAuthenticationError.new(context.provider_name)
    context.fail!
  end

  def track_renewal_rejected!
    MonitoringService.instance.track_with_added_context(
      'error',
      'Fail to rotate INSEE password',
      {
        http_response_code: context.response&.code,
        http_response_body: context.response&.body
      }
    )
  end
end
