class DGFIP::ADELIE::MakeRequest < MakeRequest::Get
  protected

  def common_request_params
    {
      userId: user_id
    }
  end

  def base_url
    "#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1"
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{context.token}"
    request['X-Correlation-ID'] = request_id
    request['X-Request-ID'] = request_id
    super
  end

  def request_id
    @request_id ||= context.params.fetch(:request_id)
  end

  def user_id
    @user_id ||= context.params.fetch(:user_id)
  end
end
