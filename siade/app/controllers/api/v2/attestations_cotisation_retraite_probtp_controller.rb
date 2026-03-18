class API::V2::AttestationsCotisationRetraitePROBTPController < API::AuthenticateEntityController
  def show
    authorize :probtp

    retrieve_attestation = SIADE::V2::Retrievers::AttestationsCotisationRetraitePROBTP.new(siret_from_params)

    retrieve_attestation.retrieve

    if retrieve_attestation.success?
      render json: { url: retrieve_attestation.document_url },  status: retrieve_attestation.http_code
    else
      render_errors(retrieve_attestation)
    end
  end

  def siret_from_params
    params.require(:siret)
  end
end
