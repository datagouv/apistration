class SIADE::V2::Retrievers::CertificatsQUALIBAT < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siret

  register_driver :certificats_qualibat, class_name: SIADE::V2::Drivers::CertificatsQUALIBAT, init_with: :siret

  fetch_attributes_through_driver :certificats_qualibat, :http_code, :document_url

  def initialize(siret)
    @siret = siret
  end

  def retrieve
    driver_certificats_qualibat.perform_request
  end
end
