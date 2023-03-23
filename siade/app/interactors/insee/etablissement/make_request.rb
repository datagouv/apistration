class INSEE::Etablissement::MakeRequest < INSEE::MakeRequest
  protected

  def request_uri
    URI([base_uri, 'entreprises', 'sirene', 'V3', 'siret', siret].join('/'))
  end

  def request_params
    {}
  end

  def handle_redirect
    context.redirect_from_siret = siret.dup

    context_for_siege_unite_legale = context.dup
    context_for_siege_unite_legale.params[:siren] = extract_siren_unite_legale_from_location

    make_request_on_siege_unite_legale = INSEE::SiegeUniteLegale::MakeRequest.call(
      context_for_siege_unite_legale
    )

    context.response = make_request_on_siege_unite_legale.response
  end

  private

  def extract_siren_unite_legale_from_location
    context.response.header['Location'].split('%3A')[-1]
  end

  def siret
    context.params[:siret]
  end
end
