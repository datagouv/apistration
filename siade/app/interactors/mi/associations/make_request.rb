class MI::Associations::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("#{mi_domain}/apim/api-asso-partenaires/api/structure/#{siret_or_rna}")
  end

  def request_params
    {
      proxy_only: true
    }
  end

  def set_headers(request)
    super
    request['X-Gravitee-Api-Key'] = mi_gravitee_api_key
  end

  private

  def mi_domain
    Siade.credentials[:mi_domain]
  end

  def mi_gravitee_api_key
    Siade.credentials[:mi_gravitee_api_key]
  end

  def siret_or_rna
    context.params[:siret_or_rna]
  end
end
