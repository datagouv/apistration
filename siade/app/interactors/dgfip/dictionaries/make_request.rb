class DGFIP::Dictionaries::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(Siade.credentials[:dgfip_liasse_fiscale_dictionnaire_url])
  end

  def request_params
    {
      siren: mandatory_siren_but_must_be_empty,
      annee: year
    }
  end

  def extra_headers(request)
    request['Cookie'] = context.cookie
    super(request)
  end

  private

  def mandatory_siren_but_must_be_empty
    ''
  end

  def year
    context.params[:year]
  end
end
