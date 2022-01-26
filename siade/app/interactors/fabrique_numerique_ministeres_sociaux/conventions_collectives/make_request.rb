class FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("https://fabrique_numerique_conventions_collectives_url.gouv.fr/#{siret}")
  end

  def request_params
    {}
  end

  private

  def siret
    context.params[:siret]
  end
end
