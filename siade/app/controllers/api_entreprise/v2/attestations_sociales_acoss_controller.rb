class APIEntreprise::V2::AttestationsSocialesACOSSController < APIEntreprise::V2::BaseController
  def show
    authorize :attestations_sociales

    retriever = cached_retriever || retrieve_attestation

    if retriever.success?
      render json: { url: retriever.document_url }, status: retriever.http_code
    else
      render_errors(retriever)
    end
  end

  private

  def retrieve_attestation
    retriever = SIADE::V2::Retrievers::AttestationsSocialesACOSS.new(params_requests)
    retriever.retrieve

    write_retriever_cache(retriever) unless at_least_one_error_kind_of?(:network_error, retriever)

    retriever
  end

  def params_requests
    {
      siren: params[:siren],
      type_attestation: params[:type_attestation],
      user_id: current_user.logstash_id,
      recipient: params[:recipient]
    }
  end

  def write_retriever_cache(retriever)
    EncryptedCache.write(cache_key, retriever, expires_in: 24.hours.to_i)
  end

  def cache_key
    request.path
  end

  def cached_retriever
    @cached_retriever ||= EncryptedCache.read(cache_key)
  end
end
