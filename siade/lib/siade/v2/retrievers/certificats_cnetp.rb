class SIADE::V2::Retrievers::CertificatsCNETP < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siren

  register_driver :certificats_cnetp, class_name: SIADE::V2::Drivers::CertificatsCNETP, init_with: :siren

  fetch_attributes_through_driver :certificats_cnetp, :http_code, :document_url

  def initialize(siren)
    @siren = siren
  end

  def retrieve
    driver_certificats_cnetp.perform_request
  end
end
