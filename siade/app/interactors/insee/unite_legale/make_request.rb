class INSEE::UniteLegale::MakeRequest < INSEE::MakeRequest
  protected

  def request_uri
    URI([base_uri, 'entreprises', sirene_version, 'siren', siren].join('/'))
  end

  def request_params
    {}
  end

  def handle_redirect
    context.redirect_from_siren = siren.dup

    context_for_new_location = context.dup
    context_for_new_location.params[:siren] = extract_siren_from_location

    make_request_on_new_location = self.class.call(
      context_for_new_location
    )

    context.response = make_request_on_new_location.response
  end

  private

  def extract_siren_from_location
    context.response.header['Location'].split('/')[-1]
  end

  def siren
    context.params[:siren]
  end
end
