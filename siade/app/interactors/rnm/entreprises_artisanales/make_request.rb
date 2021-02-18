class RNM::EntreprisesArtisanales::MakeRequest < MakeRequest
  private

  def request_uri
    URI("https://rnm_domain.gouv.fr/v2/entreprises/#{siren}")
  end

  def request_params
    {
      format: :json,
    }
  end

  def http_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_PEER,
    }
  end

  def request_verb
    :get
  end

  def siren
    context.params[:siren]
  end
end
