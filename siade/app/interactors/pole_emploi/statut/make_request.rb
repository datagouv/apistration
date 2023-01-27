class PoleEmploi::Statut::MakeRequest < MakeRequest::Post
  protected

  def request_uri
    URI(Siade.credentials[:pole_emploi_status_url])
  end

  def mocking_params
    {
      identifiant:
    }
  end

  def build_request_body
    identifiant
  end

  def set_headers(request)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{token}"
    request['X-pe-consommateur'] = "DINUM - #{user_id}"
  end

  private

  def identifiant
    context.params[:identifiant_pole_emploi]
  end

  def user_id
    context.params[:user_id]
  end

  def token
    context.token
  end
end
