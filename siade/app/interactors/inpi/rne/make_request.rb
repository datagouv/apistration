class INPI::RNE::MakeRequest < MakeRequest::Get
  protected

  def extra_headers(request)
    request['Authorization'] = "Bearer #{token}"
    super
  end

  def request_params
    {}
  end

  def request_uri
    raise NotImplementedError
  end

  def siren
    context.params[:siren]
  end

  def token
    context.token
  end
end
