class SIADE::V2::Retrievers::ExtraitCourtINPI < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siren
  register_driver :brevets, class_name: SIADE::V2::Drivers::BrevetsINPI, init_with: :siren
  register_driver :modeles, class_name: SIADE::V2::Drivers::ModelesINPI, init_with: :siren
  register_driver :marques, class_name: SIADE::V2::Drivers::MarquesINPI, init_with: :siren

  def initialize(siren)
    @siren = siren
  end

  def retrieve
    driver_brevets.perform_request
    driver_modeles.perform_request
    driver_marques.perform_request
    self
  end

  def http_code
    SIADE::V2::Utilities::HTTPCode
      .generate_best_http_code([driver_brevets.http_code, driver_modeles.http_code, driver_marques.http_code])
  end

  def count_brevets
    driver_brevets.count
  end

  def latests_brevets
    driver_brevets.latests_brevets
  end

  def count_modeles
    driver_modeles.count
  end

  def latests_modeles
    driver_modeles.latests_modeles
  end

  def count_marques
    driver_marques.count
  end

  def latests_marques
    driver_marques.latests_marques
  end
end
