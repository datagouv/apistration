class APIEntreprise::V2::ExercicesController < APIEntreprise::V2::AbstractDGFIPController
  def show
    retriever = cached_retriever || retrieve_exercice

    if retriever.success?
      render json: APIEntreprise::ExerciceSerializer::V2.new(retriever).as_json, status: retriever.http_code
    else
      render_errors(retriever)
    end
  end

  private

  def retrieve_exercice
    @retrieve_exercice ||= begin
      retriever = SIADE::V2::Retrievers::Exercices.new(params[:siret], retriever_params(dgfip_service))
      retriever.retrieve

      write_retriever_cache(retriever, expires_in: until_next_dgfip_update_in_seconds) unless at_least_one_error_cant_be_cached?(retriever)

      retriever
    end
  end

  def retriever_params(dgfip_service)
    retriever_params = params.permit(:siret)

    retriever_params[:user_id] = UserIdDGFIPService.call(current_user.id)
    retriever_params[:cookie]  = dgfip_service.cookie

    retriever_params
  end
end
