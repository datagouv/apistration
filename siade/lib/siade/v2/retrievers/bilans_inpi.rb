class SIADE::V2::Retrievers::BilansINPI < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siren, :cookie

  register_driver :bilans, class_name: SIADE::V2::Drivers::INPI::Bilans, init_with: :siren, init_options: :cookie

  fetch_attributes_through_driver :bilans, :bilans

  register_driver :get_documents, class_name: SIADE::V2::Drivers::INPI::GetDocuments, init_with: :ids_fichiers, init_options: :cookie

  fetch_attributes_through_driver :get_documents, :url_documents

  def initialize(siren, cookie)
    @siren = siren
    @cookie = cookie
  end

  def retrieve
    driver_bilans.perform_request

    driver_get_documents.perform_request if driver_bilans.success?
  end

  def http_code
    if driver_bilans.success?
      driver_get_documents.http_code
    else
      driver_bilans.http_code
    end
  end

  private

  def ids_fichiers
    @ids_fichiers ||= driver_bilans.bilans.pluck(:id_fichier)
  end
end
