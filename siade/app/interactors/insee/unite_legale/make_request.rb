class INSEE::UniteLegale::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI([base_uri, 'entreprises', 'sirene', 'V3', 'siren', siren].join('/'))
  end

  def request_params
    {}
  end

  def set_headers(request)
    request['Authorization'] = "Bearer #{token}"
    super(request)
  end

  def handle_redirect
    siren_from_location = context.response.header['Location'].split('/')[-1]
    context_for_new_location = context.dup
    context_for_new_location.params[:siren] = siren_from_location

    make_request_on_new_location = self.class.call(
      context_for_new_location
    )

    context.response = make_request_on_new_location.response
  end

  private

  def siren
    context.params[:siren]
  end

  def token
    context.token
  end

  def base_uri
    Siade.credentials[:insee_v3_domain]
  end
end
