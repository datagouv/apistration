class CIBTP::AttestationCotisationsCongesPayesChomageIntemperies::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("#{Siade.credentials[:cibtp_domain]}/apientreprise/attestationmarche")
  end

  def request_params
    {
      siret: context.params[:siret]
    }
  end

  def extra_headers(request)
    request['Authorization'] = "Bearer #{context.token}"
  end
end
