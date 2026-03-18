class SIADE::V2::Retrievers::EORIDouanes < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :eori

  register_driver :eori_douanes, class_name: SIADE::V2::Drivers::EORIDouanes, init_with: :eori

  fetch_attributes_through_driver :eori_douanes,
    :http_code,
    :numero_eori, :actif, :raison_sociale, :rue, :ville, :code_postal, :pays, :code_pays

  def initialize(eori)
    @eori = eori
  end

  def retrieve
    driver_eori_douanes.perform_request
  end
end
