class SIADE::V2::Retrievers::CertificatsAgenceBIO < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siret

  register_driver :certificats_agence_bio, class_name: SIADE::V2::Drivers::CertificatsAgenceBIO, init_with: :siret

  fetch_attributes_through_driver :certificats_agence_bio,
    :filtered_certifications_data,
    :http_code,
    :errors

  def initialize(siret)
    @siret = siret
  end

  def retrieve
    driver_certificats_agence_bio.perform_request
  end
end
