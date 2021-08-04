class API::V2::AttestationsFiscalesDGFIPController < API::V2::AbstractDGFIPController
  def show
    retrieve_attestation = SIADE::V2::Retrievers::AttestationsFiscalesDGFIP.new(retriever_params(dgfip_service))
    retrieve_attestation.retrieve

    if retrieve_attestation.success?
      render json: { url: retrieve_attestation.document_url },  status: retrieve_attestation.http_code
    else
      render_errors(retrieve_attestation)
    end
  end

  private

  def resource_scope
    :attestations_fiscales
  end

  def retriever_params(dgfip_service)
    retriever_params = params.permit(:siren, :siren_is, :siren_tva)

    retriever_params[:user_id] = UserIdDGFIPService.call(@authenticated_user.id)
    retriever_params[:cookie]  = dgfip_service.cookie

    retriever_params
  end
end
