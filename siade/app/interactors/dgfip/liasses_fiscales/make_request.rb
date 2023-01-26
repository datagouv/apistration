class DGFIP::LiassesFiscales::MakeRequest < DGFIP::AbstractMakeRequest
  protected

  def request_uri
    URI(Siade.credentials[:dgfip_liasse_fiscale_declaration_url])
  end

  def set_headers(request)
    request['Cookie'] = context.cookie
  end

  def request_params
    {
      annee: params[:year],
      siren: params[:siren],
      userId: user_id_sanitized
    }
  end

  def params
    context.params
  end
end
