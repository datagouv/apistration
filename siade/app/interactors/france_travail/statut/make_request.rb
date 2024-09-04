class FranceTravail::Statut::MakeRequest < MakeRequest::Post
  include FranceTravail::MakeRequest

  protected

  def request_uri
    URI(Siade.credentials[:pole_emploi_status_url])
  end

  def build_request_body
    identifiant
  end
end
