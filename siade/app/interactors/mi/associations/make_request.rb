class MI::Associations::MakeRequest < MakeRequest::Get
  protected

  def mocking_params
    if context.params[:siret_or_rna].present?
      {
        siret_or_rna: id
      }
    elsif context.params[:siren_or_rna].present?
      {
        siren_or_rna: id
      }
    else
      super
    end
  end

  def request_uri
    URI("#{mi_domain}/apim/api-asso-partenaires/api/structure/#{id}")
  end

  def request_params
    {
      proxy_only: true
    }
  end

  def extra_headers(request)
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

  def id
    context.params[:id]
  end
end
