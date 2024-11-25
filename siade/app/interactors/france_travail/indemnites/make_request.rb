class FranceTravail::Indemnites::MakeRequest < MakeRequest::Get
  include FranceTravail::MakeRequest

  protected

  def request_uri
    URI(Siade.credentials[:france_travail_indemnites_url])
  end

  def mocking_params
    {
      identifiant:
    }
  end

  def request_params
    {
      loginMnemotechnique: identifiant
    }
  end
end
