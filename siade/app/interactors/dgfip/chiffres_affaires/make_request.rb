class DGFIP::ChiffresAffaires::MakeRequest < DGFIP::AbstractMakeRequest
  protected

  def request_uri
    URI(Siade.credentials[:dgfip_chiffres_affaires_url])
  end

  def extra_headers(request)
    request['Cookie'] = context.cookie
  end

  def request_params
    {
      userId: user_id_sanitized,
      siret: params[:siret]
    }
  end
end
