class SIADE::V2::Drivers::CartesProfessionnellesFNTP < SIADE::V2::Drivers::GenericDriver
  include SIADE::V2::Drivers::SelfHostedDocumentDriver

  default_to_nil_raw_fetching_methods :document_url

  attr_accessor :siren

  def initialize(hash)
    @siren = hash[:siren]
  end

  def provider_name
    'FNTP'
  end

  def request
    @request ||= SIADE::V2::Requests::CartesProfessionnellesFNTP.new(siren)
  end

  private

  def body
    @body ||= response.body
  end

  def document_file_type
    SIADE::SelfHostedDocument::File::PDF
  end

  def document_name
    'carte_professionnelle_fntp'
  end

  def document_source
    body
  end

  def document_storage_method
    :store_from_binary
  end
end
