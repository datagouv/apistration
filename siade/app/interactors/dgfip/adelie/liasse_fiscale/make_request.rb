class DGFIP::ADELIE::LiasseFiscale::MakeRequest < DGFIP::ADELIE::MakeRequest
  def request_params
    common_request_params.merge(
      annee: context.params[:year],
      siren: context.params[:siren]
    )
  end

  def request_uri
    URI("#{base_url}/getLiasseFiscale")
  end
end
