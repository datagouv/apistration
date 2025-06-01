class DataSubvention::Subventions::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("#{data_subvention_url}/association/#{context.params[:siren_or_siret_or_rna]}/grants")
  end

  def request_params
    {}
  end

  def extra_headers(request)
    request['x-access-token'] = data_subvention_token
    super
  end

  private

  def data_subvention_token
    context.token
  end

  def data_subvention_url
    Siade.credentials[:data_subvention_url]
  end
end
