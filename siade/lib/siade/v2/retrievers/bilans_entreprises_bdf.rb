class SIADE::V2::Retrievers::BilansEntreprisesBDF < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siren
  register_driver :bilans_entreprises_bdf, class_name: SIADE::V2::Drivers::BilansEntreprisesBDF, init_with: :siren
  fetch_attributes_through_driver :bilans_entreprises_bdf,
                                  :http_code,
                                  :bilans,
                                  :monnaie

  def initialize(siren)
    @siren = siren
  end

  def retrieve
    driver_bilans_entreprises_bdf.perform_request
  end
end
