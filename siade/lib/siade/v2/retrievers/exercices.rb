class SIADE::V2::Retrievers::Exercices < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siret, :driver_options

  register_driver :exercice, class_name: SIADE::V2::Drivers::Exercices, init_with: :siret, init_options: :driver_options

  fetch_attributes_through_driver :exercice,
    :http_code,
    :liste_ca

  def initialize(siret, options)
    @siret = siret
    @driver_options = options
  end

  def retrieve
    driver_exercice.perform_request
  end
end
