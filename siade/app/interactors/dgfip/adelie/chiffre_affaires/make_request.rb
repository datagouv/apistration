class DGFIP::ADELIE::ChiffreAffaires::MakeRequest < DGFIP::ADELIE::MakeRequest
  def request_params
    common_request_params.merge(
      siret: context.params[:siret]
    )
  end

  def request_uri
    URI("#{base_url}/chiffreAffaires")
  end
end
