class API::V2::CertificatsOPQIBIController < API::V2::BaseController
  def show
    authorize :certificat_opqibi

    retrieve_opqibi = SIADE::V2::Retrievers::CertificatsOPQIBI.new(siren)

    retrieve_opqibi.retrieve

    if retrieve_opqibi.success?
      render json: ::CertificatOPQIBISerializer::V2.new(retrieve_opqibi).as_json, status: retrieve_opqibi.http_code
    else
      render_errors(retrieve_opqibi)
    end
  end

  private

  def siren
    params.require(:siren)
  end
end
