class SIADE::V2::Retrievers::CartesProfessionnellesFNTP < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siren
  register_driver :fntp, class_name: SIADE::V2::Drivers::CartesProfessionnellesFNTP, init_with: :siren
  fetch_attributes_through_driver :fntp, :http_code, :document_url

  def initialize(siren)
    @siren = siren
  end

  def retrieve
    driver_fntp.perform_request
  end
end
