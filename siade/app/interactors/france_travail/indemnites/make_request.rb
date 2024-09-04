class FranceTravail::Indemnites::MakeRequest < MakeRequest::Get
  include FranceTravail::MakeRequest

  protected

  def request_uri
    URI(Siade.credentials[:pole_emploi_indemnites_url])
  end

  def request_params
    {
      loginMnemotechnique: identifiant
    }
  end
end
