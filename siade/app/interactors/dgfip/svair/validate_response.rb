class DGFIP::SVAIR::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! unless http_ok?

    resource_not_found! if html_nodes.css('#nonTrouve').any?
    access_denied! if html_nodes.css('.interdit').any?

    return if data_present?

    unknown_provider_response!
  end

  private

  def data_present?
    response.body.include?('L\'administration fiscale certifie l\'authenticité du document présenté')
  end

  def access_denied!
    fail_with_error!(DGFIPSVAIRAccessDeniedError.new)
  end

  def html_nodes
    @html_nodes ||= Nokogiri.XML(response.body)
  end
end
