class FranceTravail::Statut::MakeRequest < MakeRequest::Post
  include FranceTravail::MakeRequest

  protected

  def request_uri
    URI(Siade.credentials[:france_travail_status_url])
  end

  def mocking_params
    {
      identifiant:
    }
  end

  def build_request_body
    identifiant
  end
end
