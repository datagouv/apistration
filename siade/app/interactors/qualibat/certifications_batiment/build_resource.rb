class QUALIBAT::CertificationsBatiment::BuildResource < BuildResource
  def resource_attributes
    {
      document_url: context.url,
      document_url_expires_in: context.expires_in
    }.merge(extracted_data_from_pdf)
  end

  private

  def extracted_data_from_pdf
    return empty_extraction if context.params[:api_version].to_s == '3'

    QUALIBATCertificationsBatimentExtractor.new(context.content).perform
  rescue QUALIBATCertificationsBatimentExtractor::PDFNotSupported => e
    track_not_supported_pdf(e)

    empty_extraction.merge(
      extractor_error: "#{e.kind}_pdf_not_supported"
    )
  rescue PDFExtractor::InvalidFile => e
    track_invalid_file(e)

    empty_extraction.merge(
      extractor_error: 'invalid_file'
    )
  end

  def track_not_supported_pdf(exception)
    monitoring_service.track(
      :info,
      "[Qualibat] PDF '#{exception.kind}' not supported"
    )
  end

  def track_invalid_file(_exception)
    monitoring_service.track(
      :error,
      '[Qualibat] PDF is not valid'
    )
  end

  def empty_extraction
    {
      date_emission: nil,
      date_fin_validite: nil,
      entity: {
        assurance_responsabilite_travaux: {
          nom: nil,
          numero: nil
        },
        assurance_responsabilite_civile: {
          nom: nil,
          numero: nil
        },
        certifications: []
      }
    }
  end

  def monitoring_service
    @monitoring_service ||= MonitoringService.instance
  end
end
