class DataSubvention::Subventions::MakeRequest < MakeRequest::Get
  include ResourceHelpers

  protected

  def api_call_with_error_handling
    response = super

    return response unless stale_token_rejected?

    context.token_renewed = true

    DataSubvention::Subventions::Authenticate.invalidate_cached_token!
    DataSubvention::Subventions::Authenticate.call!(context)

    super
  end

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

  def stale_token_rejected?
    context.token_renewed.blank? && http_unauthorized?
  end

  def data_subvention_token
    context.token
  end

  def data_subvention_url
    Siade.credentials[:data_subvention_url]
  end
end
