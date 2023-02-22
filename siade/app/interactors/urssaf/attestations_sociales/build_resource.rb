class URSSAF::AttestationsSociales::BuildResource < BuildResource
  def resource_attributes
    if document_present?
      document_data = extract_data_from_document!

      {
        entity_status_code: 'ok',
        document_url: context.url,
        document_url_expires_in: context.expires_in,
        date_debut_validite: document_data[:date_debut_validite],
        code_securite: document_data[:code_securite],
        date_fin_validite: extract_date_fin_validite_from_date_debut_validite(document_data[:date_debut_validite])
      }
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

  def extract_date_fin_validite_from_date_debut_validite(date_debut_validite)
    (date_debut_validite + 6.months).end_of_month.to_date
  end

  def extract_data_from_document!
    URSSAFAttestationVigilanceExtractor.new(decoded_body).perform
  end

  def decoded_body
    @decoded_body ||= Base64.strict_decode64(context.response.body)
  end
end
