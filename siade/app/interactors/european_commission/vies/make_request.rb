class EuropeanCommission::VIES::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI(european_commission_url)
  end

  def request_params
    {}
  end

  private

  def european_commission_url
    "https://european_commission_vies_url.gouv.fr/#{tva_number_without_fr}"
  end

  def tva_number_without_fr
    tva_number[2..]
  end

  def tva_number
    context.tva_number
  end
end
