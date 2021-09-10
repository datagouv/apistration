class SIADE::V2::Retrievers::ConventionsCollectives < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siret

  register_driver :conventions_collectives, class_name: SIADE::V2::Drivers::ConventionsCollectives, init_with: :siret

  fetch_attributes_through_driver :conventions_collectives,
    :conventions,
    :http_code

  def initialize(siret)
    @siret = siret
  end

  def retrieve
    driver_conventions_collectives.perform_request
  end
end
