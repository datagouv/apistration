class SIADE::V2::Retrievers::CotisationsMSA < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siret

  register_driver :cotisation_msa, class_name: SIADE::V2::Drivers::CotisationsMSA, init_with: :siret

  fetch_attributes_through_driver :cotisation_msa,
    :analyse_en_cours?, :a_jour?, :http_code, :errors

  def initialize(siret)
    @siret = siret
  end

  def retrieve
    driver_cotisation_msa.perform_request
  end
end
