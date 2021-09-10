class SIADE::V2::Retrievers::ExtraitsRCSInfogreffe < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siren

  register_driver :infogreffe, class_name: SIADE::V2::Drivers::Infogreffe, init_with: :siren

  fetch_attributes_through_driver :infogreffe,
    :http_code,
    :liste_observations,
    :date_immatriculation,
    :date_immatriculation_timestamp,
    :date_extrait
  def initialize(siren)
    @siren = siren
  end

  def retrieve
    driver_infogreffe.perform_request
  end
end
