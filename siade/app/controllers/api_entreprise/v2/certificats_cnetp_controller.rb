class APIEntreprise::V2::CertificatsCNETPController < APIEntreprise::V2::BaseController
  def show
    authorize :certificat_cnetp

    retrieve_certificate = SIADE::V2::Retrievers::CertificatsCNETP.new(siren_from_params)
    retrieve_certificate.retrieve

    if retrieve_certificate.success?
      render json: { url: retrieve_certificate.document_url }, status: retrieve_certificate.http_code
    else
      render_errors(retrieve_certificate)
    end
  end

  def siren_from_params
    params.require(:siren)
  end
end
