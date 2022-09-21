class DGFIP::Dictionaries::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(Siade.credentials[:dgfip_liasse_fiscale_dictionnaire_url])
  end

  def request_params
    {
      siren: '',
      annee: year
    }
  end

  def set_headers(request)
    request['Cookie'] = context.cookie
    super(request)
  end

  private

  def year
    context.params[:year]
  end
end
