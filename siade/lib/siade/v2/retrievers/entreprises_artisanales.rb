class SIADE::V2::Retrievers::EntreprisesArtisanales < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siren

  register_driver :entreprises_artisanales,
    class_name: SIADE::V2::Drivers::EntreprisesArtisanales,
    init_with: :siren

  fetch_attributes_through_driver :entreprises_artisanales,
    :entreprise,
    :http_code

  def initialize(siren)
    @siren = siren
  end

  def retrieve
    driver_entreprises_artisanales.perform_request
  end
end
