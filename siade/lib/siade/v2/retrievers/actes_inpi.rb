class SIADE::V2::Retrievers::ActesINPI < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siren, :cookie

  register_driver :actes, class_name: SIADE::V2::Drivers::INPI::Actes, init_with: :siren, init_options: :cookie

  fetch_attributes_through_driver :actes, :actes

  register_driver :get_documents, class_name: SIADE::V2::Drivers::INPI::GetDocuments, init_with: :ids_fichiers, init_options: :cookie

  fetch_attributes_through_driver :get_documents, :url_documents

  def initialize(siren, cookie)
    @siren = siren
    @cookie = cookie
  end

  def retrieve
    driver_actes.perform_request

    driver_get_documents.perform_request if driver_actes.success?
  end

  def http_code
    if driver_actes.success?
      driver_get_documents.http_code
    else
      driver_actes.http_code
    end
  end

  private

  def ids_fichiers
    @ids_fichiers ||= driver_actes.actes.pluck(:id_fichier)
  end
end
