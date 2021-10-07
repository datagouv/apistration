class SIADE::V2::Retrievers::CertificatsRGEADEME < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siret

  register_driver :certificats_rge_ademe, class_name: SIADE::V2::Drivers::CertificatsRGEADEME, init_with: :siret, init_options: :user_params

  fetch_attributes_through_driver :certificats_rge_ademe,
    :qualifications, :domaines, :http_code, :errors

  def initialize(params)
    @siret = params[:siret]
    @skip_pdf = params[:skip_pdf] || false
  end

  def retrieve
    driver_certificats_rge_ademe.perform_request
  end

  private

  def user_params
    { skip_pdf: @skip_pdf }
  end
end
