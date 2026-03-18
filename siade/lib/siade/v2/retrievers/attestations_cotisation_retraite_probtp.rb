class SIADE::V2::Retrievers::AttestationsCotisationRetraitePROBTP < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siret
  register_driver :attestation_cotisation_retraite_probtp, class_name: SIADE::V2::Drivers::AttestationsCotisationRetraitePROBTP, init_with: :siret

  fetch_attributes_through_driver :attestation_cotisation_retraite_probtp, :http_code, :document_url

  def initialize(siret)
    @siret = siret
  end

  def retrieve
    driver_attestation_cotisation_retraite_probtp.perform_request
  end
end
