class SIADE::V2::Drivers::CertificatsQUALIBAT < SIADE::V2::Drivers::GenericDriver
  include SIADE::V2::Drivers::SelfHostedDocumentDriver

  default_to_nil_raw_fetching_methods :document_url

  attr_reader :siret

  def initialize(hash)
    @siret = hash[:siret]
  end

  def provider_name
    'Qualibat'
  end

  def request
    @request ||= SIADE::V2::Requests::CertificatsQUALIBAT.new(siret)
  end

  private

  def body
    @body ||= JSON.parse(response.body, symbolize_names: true)
  rescue JSON::ParserError
    {}
  end

  def document_file_type
    SIADE::SelfHostedDocument::File::PDF
  end

  def document_name
    'certificat_qualibat'
  end

  def document_source
    body[:URL]
  end

  def document_storage_method
    :store_from_url
  end
end
