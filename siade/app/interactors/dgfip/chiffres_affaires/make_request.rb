class DGFIP::ChiffresAffaires::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(Siade.credentials[:dgfip_chiffres_affaires_url])
  end

  def set_headers(request)
    request['Cookie'] = context.cookie
  end

  def request_params
    {
      userId: user_id_sanitized,
      siret: params[:siret]
    }
  end

  private

  def params
    context.params
  end

  def user_id_sanitized
    UserIdDGFIPService.call(params[:user_id])
  end
end
