class MSA::ConformitesCotisations::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("#{Siade.credentials[:msa_conformites_cotisations_url]}/#{siret}")
  end

  def request_params
    {}
  end

  private

  def siret
    context.params[:siret]
  end
end
