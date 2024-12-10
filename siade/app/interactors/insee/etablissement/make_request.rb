class INSEE::Etablissement::MakeRequest < INSEE::MakeRequest
  protected

  def request_uri
    URI([base_uri, sirene_base_path, 'siret', siret].join('/'))
  end

  def request_params
    {}
  end

  def handle_redirect
    context.redirect_from_siret = siret.dup

    context_for_new_location = context.dup
    context_for_new_location.params[:siret] = extract_siret_from_location

    make_request_on_new_location = self.class.call(
      context_for_new_location
    )

    context.response = make_request_on_new_location.response
  end

  private

  def extract_siret_from_location
    context.response.header['Location'].split('/')[-1]
  end

  def siret
    context.params[:siret]
  end
end
