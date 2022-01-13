class RNM::EntreprisesArtisanales::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("#{rnm_domain}/v2/entreprises/#{siren}")
  end

  def request_params
    {
      format: :json
    }
  end

  private

  def rnm_domain
    Siade.credentials[:rnm_domain]
  end

  def siren
    context.params[:siren]
  end
end
