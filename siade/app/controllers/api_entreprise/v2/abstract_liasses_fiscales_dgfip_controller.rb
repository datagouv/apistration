class APIEntreprise::V2::AbstractLiassesFiscalesDGFIPController < APIEntreprise::V2::AbstractDGFIPController
  protected

  def dgfip_action(request_type:)
    retriever = cached_retriever || retrieve_liasse_fiscale(request_type:)

    if retriever.success?
      render json: retriever.response, status: :ok
    else
      render_errors(retriever)
    end
  end

  def retrieve_liasse_fiscale(request_type:)
    @retrieve_liasse_fiscale ||= begin
      retriever = SIADE::V2::Retrievers::LiassesFiscalesDGFIP.new(retriever_params.merge(request_type: request_type))
      retriever.retrieve

      write_retriever_cache(retriever, expires_in: until_next_dgfip_update_in_seconds) unless at_least_one_error_cant_be_cached?(retriever)

      retriever
    end
  end

  def retriever_params
    retriever_params = params.permit(:siren, :annee)
    retriever_params[:cookie]  = dgfip_service.cookie
    retriever_params[:user_id] = UserIdDGFIPService.call(current_user.id)

    retriever_params
  end
end
