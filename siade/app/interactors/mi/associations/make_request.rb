class MI::Associations::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("#{mi_domain}/api-asso/api/structure/#{siret_or_rna}")
  end

  def request_params
    {
      proxy_only: true
    }
  end

  private

  def mi_domain
    Siade.credentials[:mi_domain]
  end

  def siret_or_rna
    context.params[:siret_or_rna]
  end
end
