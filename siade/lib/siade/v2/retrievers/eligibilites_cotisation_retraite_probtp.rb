class SIADE::V2::Retrievers::EligibilitesCotisationRetraitePROBTP < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siret
  register_driver :eligibilite_retraite_probtp, class_name: SIADE::V2::Drivers::EligibilitesCotisationRetraitePROBTP, init_with: :siret

  fetch_attributes_through_driver :eligibilite_retraite_probtp, :eligible?, :message, :http_code

  def initialize(siret)
    @siret = siret
  end

  def retrieve
    driver_eligibilite_retraite_probtp.perform_request
  end
end
