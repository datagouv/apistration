class PoleEmploi::Statut::MakeRequest < MakeRequest::Post
  include PoleEmploi::MakeRequest

  protected

  def request_uri
    URI(Siade.credentials[:pole_emploi_status_url])
  end

  def build_request_body
    identifiant
  end
end
