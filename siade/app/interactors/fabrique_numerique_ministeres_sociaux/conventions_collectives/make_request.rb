class FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("#{Siade.credentials[:fabrique_numerique_conventions_collectives_url]}/#{siret}")
  end

  def request_params
    {}
  end

  private

  def siret
    context.params[:siret]
  end
end
