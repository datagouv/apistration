require 'open-uri'

class API::V2::CertificatsQUALIBATController < API::AuthenticateEntityController
  def show
    authorize :qualibat

    retrieve_certificat = SIADE::V2::Retrievers::CertificatsQUALIBAT.new(siret_from_params)
    retrieve_certificat.retrieve

    if retrieve_certificat.success?
      render json: { url: retrieve_certificat.document_url }, status: retrieve_certificat.http_code
    else
      render_errors(retrieve_certificat)
    end
  end

  private

  def siret_from_params
    params.require(:siret)
  end
end
