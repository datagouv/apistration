class RNM::EntreprisesArtisanales::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("https://rnm_domain.gouv.fr/v2/entreprises/#{siren}")
  end

  def request_params
    {
      format: :json,
    }
  end

  private

  def siren
    context.params[:siren]
  end
end
