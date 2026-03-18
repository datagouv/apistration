class API::V2::ExercicesController < API::V2::AbstractDGFIPController
  def show
    authorize :exercices

    retrieve_exercice = SIADE::V2::Retrievers::Exercices.new(params[:siret], retriever_params(dgfip_service))
    retrieve_exercice.retrieve

    if retrieve_exercice.success?
      render json: ExerciceSerializer::V2.new(retrieve_exercice).as_json,  status: retrieve_exercice.http_code
    else
      render_errors(retrieve_exercice)
    end
  end

  private

  def retriever_params(dgfip_service)
    retriever_params = params.permit(:siret)

    retriever_params[:user_id] = UserIdDGFIPService.call(@authenticated_user.id)
    retriever_params[:cookie]  = dgfip_service.cookie

    retriever_params
  end
end
