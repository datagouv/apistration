class ACOSS::AttestationsSociales::MakeRequest < MakeRequest::Post
  protected

  def request_uri
    URI("#{acoss_domain}#{acoss_path}")
  end

  def request_params
    {
      typeAttestation: 'AVG_UR',
      siren: context.params[:siren],
      idClient: context.params[:user_id],
      beneficiaire: context.params[:recipient],
    }.to_json
  end

  def set_headers(request)
    request['Content-Type'] = 'application/json'
    request['authorization'] = "Bearer #{token}"
  end

  private

  def token
    context.token
  end

  def acoss_domain
    Siade.credentials[:acoss_domain]
  end

  def acoss_path
    '/attn/entreprise/v1/demandes/api_entreprise'
  end
end
