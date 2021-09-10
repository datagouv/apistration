class SIADE::V2::Retrievers::DocumentsAssociations < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :association_id

  register_driver :association, class_name: SIADE::V2::Drivers::Associations, init_with: :association_id

  fetch_attributes_through_driver :association,
    :nombre_documents, :documents

  def initialize(association_id)
    @association_id = association_id
  end

  def retrieve
    driver_association.perform_request
  end

  def http_code
    if driver_association.http_code <= 206 && driver_association.nombre_documents == 'Donnée indisponible' # driver http_code is only set to 206 on failing attribute access attempt
      driver_association.errors.clear
      driver_association.errors << incorrect_bridge_error
      502
    else
      driver_association.http_code
    end
  end

  def incorrect_bridge_error
    ProviderUnknownError.new('RNA')
  end
end
