class SIADE::V2::Retrievers::AttestationsAGEFIPH < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siret
  register_driver :attestation_agefiph, class_name: SIADE::V2::Drivers::AttestationsAGEFIPH, init_with: :siret

  fetch_attributes_through_driver :attestation_agefiph,
    :derniere_annee_de_conformite_connue,
    :dump_date,
    :success?,
    :http_code


  def initialize(siret)
    @siret = siret
  end

  def retrieve
    driver_attestation_agefiph.perform_request
  end
end
