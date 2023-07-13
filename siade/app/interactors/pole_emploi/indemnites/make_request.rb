class PoleEmploi::Indemnites::MakeRequest < MakeRequest::Get
  include PoleEmploi::MakeRequest

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
