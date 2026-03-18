class SIADE::V2::Retrievers::CertificatsOPQIBI < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siren
  register_driver :opqibi, class_name: SIADE::V2::Drivers::CertificatsOPQIBI, init_with: :siren
  fetch_attributes_through_driver :opqibi,
                                  :http_code,
                                  :numero_certificat, :date_de_delivrance_du_certificat, :duree_de_validite_du_certificat, :assurance, :url,
                                  :qualifications,
                                  :date_de_validite_des_qualifications,
                                  :qualifications_probatoires,
                                  :date_de_validite_des_qualifications_probatoires

  def initialize(siren)
    @siren = siren
  end

  def retrieve
    driver_opqibi.perform_request
  end
end
