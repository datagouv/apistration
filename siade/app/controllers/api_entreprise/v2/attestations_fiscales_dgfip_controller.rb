class APIEntreprise::V2::AttestationsFiscalesDGFIPController < APIEntreprise::V2::AbstractDGFIPController
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
      retriever = SIADE::V2::Retrievers::AttestationsFiscalesDGFIP.new(retriever_params(dgfip_service))
      retriever.retrieve

      write_retriever_cache(retriever) unless at_least_one_error_kind_of?(:network_error, retriever)

      retriever
    end
  end

  def retriever_params(dgfip_service)
    retriever_params = params.permit(:siren, :siren_is, :siren_tva)

    retriever_params[:user_id] = UserIdDGFIPService.call(current_user.id)
    retriever_params[:cookie]  = dgfip_service.cookie

    retriever_params
  end

  def cache_key
    request.path << params.permit(:siren_is, :siren_tva).to_query
  end
end
