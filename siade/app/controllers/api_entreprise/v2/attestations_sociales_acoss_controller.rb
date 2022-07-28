class APIEntreprise::V2::AttestationsSocialesACOSSController < APIEntreprise::V2::BaseController
  def show
    authorize :attestations_sociales

    retrieve_attestation = SIADE::V2::Retrievers::AttestationsSocialesACOSS.new(params_requests)
    retrieve_attestation.retrieve

    if retrieve_attestation.success?
      render json: { url: retrieve_attestation.document_url }, status: retrieve_attestation.http_code
    else
      render_errors(retrieve_attestation)
    end
  end

  private

  def params_requests
    {
      siren: params[:siren],
      type_attestation: params[:type_attestation],
      user_id: current_user.logstash_id,
      recipient: params[:recipient]
    }
  end
end
