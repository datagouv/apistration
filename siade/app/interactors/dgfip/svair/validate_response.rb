class DGFIP::SVAIR::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! unless http_ok?

    invalid_provider_response! if html_nodes.css('#service_indispo').any?
    handle_not_found if html_nodes.css('#nonTrouve').any?
    access_denied! if html_nodes.css('.interdit').any?

    return if data_present?

    unknown_provider_response!
  end

  private

  def handle_not_found
    make_payload_cacheable!
    resource_not_found!
  end

  def data_present?
    response.body.include?('L\'administration fiscale certifie l\'authenticité du document présenté')
  end

  def resource_not_found!
    fail_with_error!(build_error(::NotFoundError, 'Les paramètres fournis sont incorrects ou ne correspondent pas à un avis'))
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
