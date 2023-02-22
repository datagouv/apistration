class URSSAF::AttestationsSociales::UploadDocument < UploadDocumentOrganizer
  around do |interactor|
    next if soft_error?

    interactor.call
  end

  organize Documents::StoreFromBase64

  def source_file_content
    context.response.body
  end

  def file_type
    'pdf'
  end

  def filename
    'attestation-vigilance-urssaf'
  end

  def soft_error?
    json_errors.any? { |error| error[:code] == 'FUNC502' }
  end

  def json_errors
    @json_errors ||= JSON.parse(
      context.response.body,
      symbolize_names: true
    )
  rescue JSON::ParserError
    []
  end
end
