class SIADE::V2::Drivers::AttestationsCotisationRetraitePROBTP < SIADE::V2::Drivers::GenericDriver
  include SIADE::V2::Drivers::SelfHostedDocumentDriver

  default_to_nil_raw_fetching_methods :document_url

  attr_reader :siret

  def initialize(hash)
    @siret = hash[:siret]
  end

  def provider_name
    'ProBTP'
  end

  def request
    @request ||= SIADE::V2::Requests::AttestationsCotisationRetraitePROBTP.new(siret)
  end

  def body
    @body ||= JSON.parse(response.body, symbolize_names: true)
  end

  private

  def document_file_type
    SIADE::SelfHostedDocument::File::PDF
  end

  def document_name
    'attestation_cotisation_retraite_probtp'
  end

  def document_source
    encoded_content
  end

  def document_storage_method
    :store_from_base64
  end

  def encoded_content
    body[:data]
  end
end
