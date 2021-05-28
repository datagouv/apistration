class API::V2::CertificatsRGEAdemeController < API::V2::BaseController
  def show
    authorize :certificat_rge_ademe

    retrieve_certificats_rge = SIADE::V2::Retrievers::CertificatsRGEAdeme.new(request_params)
    retrieve_certificats_rge.retrieve

    if retrieve_certificats_rge.success?
      render json: CertificatRGEAdemeSerializer.new(retrieve_certificats_rge).as_json,
        status: retrieve_certificats_rge.http_code
    else
      render_errors(retrieve_certificats_rge)
    end
  end

  def request_params
    params.require(:siret)
    params.permit(:siret, :skip_pdf)
  end
end
