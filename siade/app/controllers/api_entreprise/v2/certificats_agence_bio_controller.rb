class APIEntreprise::V2::CertificatsAgenceBIOController < APIEntreprise::V2::BaseController
  def show
    retrieve_certificats_bio = SIADE::V2::Retrievers::CertificatsAgenceBIO.new(request_params)
    retrieve_certificats_bio.retrieve

    if retrieve_certificats_bio.success?
      response_data = retrieve_certificats_bio.filtered_certifications_data
      render json: response_data, status: retrieve_certificats_bio.http_code
    else
      render_errors(retrieve_certificats_bio)
    end
  end

  def request_params
    params.require(:siret)
  end
end
