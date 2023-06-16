class APIEntreprise::V2::AttestationsSocialesACOSSController < APIEntreprise::V2::BaseController
  def show
    retriever = cached_retriever || retrieve_attestation

    if retriever.success?
      render json: { url: retriever.document_url }, status: retriever.http_code
    else
      render_errors(retriever)
    end
  end

  private

  def retrieve_attestation
    @retrieve_attestation ||= begin
      retriever = SIADE::V2::Retrievers::AttestationsSocialesACOSS.new(params_requests)
      retriever.retrieve

      write_retriever_cache(retriever, expires_in: 24.hours.to_i) unless at_least_one_error_cant_be_cached?(retriever)

      retriever
    end
  end

  def params_requests
    {
      siren: params[:siren],
      type_attestation: params[:type_attestation],
      user_id: current_user.logstash_id,
      recipient: params[:recipient]
    }
  end
end
