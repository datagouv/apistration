class DGFIP::ADELIE::Dictionnaire::MakeRequest < DGFIP::ADELIE::MakeRequest
  def request_params
    common_request_params.merge(
      annee: context.params[:year]
    )
  end

  def request_uri
    URI("#{base_url}/dictionnaire")
  end
end
