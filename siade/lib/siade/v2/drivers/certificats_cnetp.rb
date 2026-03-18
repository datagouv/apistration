class SIADE::V2::Drivers::CertificatsCNETP < SIADE::V2::Drivers::GenericDriver
  include SIADE::V2::Drivers::SelfHostedDocumentDriver

  default_to_nil_raw_fetching_methods :document_url

  attr_accessor :siren

  def initialize(hash)
    @siren = hash[:siren]
  end

  def provider_name
    'CNETP'
  end

  def request
    @request ||= SIADE::V2::Requests::CertificatsCNETP.new(siren)
  end

  private

  def document_file_type
    SIADE::SelfHostedDocument::File::PDF
  end

  def document_name
    'certificat_cnetp'
  end

  def document_source
    response.body
  end

  def document_storage_method
    :store_from_binary
  end
end
