class URSSAF::AttestationsSociales::BuildResource < BuildResource
  def resource_attributes
    if document_present?
      document_data = extract_data_from_document

      {
        entity_status_code: 'ok',
        document_url: context.url,
        document_url_expires_in: context.url_expires_in,
        date_debut_validite: document_data[:date_debut_validite],
        code_securite: document_data[:code_securite],
        date_fin_validite: extract_date_fin_validite(document_data[:date_debut_validite]),
        extractor_error: document_data[:extractor_error]
      }.compact
    elsif cannot_deliver_document?
      {
        entity_status_code: 'refus_de_delivrance'
      }.merge(empty_document_attributes)
    end
  end

  private

  def document_present?
    context.url.present?
  end

  def cannot_deliver_document?
    json_errors.any? { |error| error[:code] == 'FUNC502' }
  end

  def json_errors
    @json_errors ||= JSON.parse(
      body,
      symbolize_names: true
    )
  rescue JSON::ParserError
    []
  end

  def empty_document_attributes
    {
      document_url: nil,
      document_url_expires_in: nil,
      date_debut_validite: nil,
      date_fin_validite: nil,
      code_securite: nil
    }
  end

  def extract_date_fin_validite(date_debut_validite)
    return nil if date_debut_validite.nil?

    (date_debut_validite + 6.months).end_of_month.to_date
  end

  def extract_data_from_document
    URSSAFAttestationVigilanceExtractor.new(decoded_body).perform
  rescue PDFExtractor::InvalidFile
    track_invalid_file
    empty_extraction.merge(extractor_error: 'invalid_file')
  end

  def track_invalid_file
    monitoring_service.track_with_added_context(
      'info',
      '[URSSAF] PDF extraction failed',
      { siren: }
    )
  end

  def empty_extraction
    {
      date_debut_validite: nil,
      code_securite: nil
    }
  end

  def decoded_body
    @decoded_body ||= Base64.strict_decode64(context.response.body)
  end

  def siren
    context.params[:siren]
  end

  def monitoring_service
    @monitoring_service ||= MonitoringService.instance
  end
end
