class MI::Associations::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("https://siva.jeunesse-sports.gouv.fr/api-asso/api/structure/#{siret_or_rna}")
  end

  def request_params
    {
      proxy_only: true
    }
  end

  private

  def siret_or_rna
    context.params[:siret_or_rna]
  end
end
