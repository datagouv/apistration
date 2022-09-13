class DGFIP::SVAIR::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! unless http_ok?

    if html_nodes.css('#nonTrouve').any?
      make_payload_cacheable!
      resource_not_found!
    end

    access_denied! if html_nodes.css('.interdit').any?

    return if data_present?

    unknown_provider_response!
  end

  private

  def data_present?
    response.body.include?('L\'administration fiscale certifie l\'authenticité du document présenté')
  end

  def access_denied!
    track_access_denied
    fail_with_error!(DGFIPSVAIRAccessDeniedError.new)
  end

  def html_nodes
    @html_nodes ||= Nokogiri.XML(response.body)
  end

  def track_access_denied
    MonitoringService.instance.track(
      'error',
      'DGFIP SVAIR: access denied'
    )
  end
end
