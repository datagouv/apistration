class DGFIP::TVA::MakeRequest < MakeRequest::Get
  protected

  def mocking_params
    context.params
  end

  def request_uri
    URI("#{base_url}/api/resources/#{resource_id}/data/")
  end

  def request_params
    {
      vat_no__exact: tva_number_without_fr,
      page_size: 1
    }
  end

  private

  def api_call
    return fail_to_request_provider!(ProviderUnavailable) if resource_id.blank?

    super
  end

  def base_url
    Siade.credentials[:dgfip_tva_base_url]
  end

  def resource_id
    Siade.credentials[:dgfip_tva_resource_id]
  end

  def tva_number_without_fr
    context.tva_number[2..]
  end
end
