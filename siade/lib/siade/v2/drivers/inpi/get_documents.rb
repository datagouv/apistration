class SIADE::V2::Drivers::INPI::GetDocuments < SIADE::V2::Drivers::GenericDriver
  include SIADE::V2::Drivers::SelfHostedDocumentDriver

  default_to_nil_raw_fetching_methods :url_documents

  attr_accessor :ids_fichiers, :cookie

  def initialize(ids_fichiers:, cookie:)
    @ids_fichiers = ids_fichiers
    @cookie = cookie
  end

  def provider_name
    'INPI'
  end

  def request
    @request ||= SIADE::V2::Requests::INPI::GetDocuments.new(@ids_fichiers, @cookie)
  end

  private

  def document_file_type
    SIADE::SelfHostedDocument::File::ZIP
  end

  def document_name
    'all_documents'
  end

  def document_source
    response.body
  end

  def document_storage_method
    :store_from_binary
  end

  def ids_fichiers
    json_documents.map { |doc| doc[:idFichier] }.join(',')
  end

  def inpi_url
    Siade.credentials[:inpi_url]
  end

  def url_documents_raw
    document_url_raw
  end
end
