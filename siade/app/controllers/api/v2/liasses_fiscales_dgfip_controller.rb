class API::V2::LiassesFiscalesDGFIPController < API::V2::AbstractDGFIPController
  def show
    dgfip_action(request_type: :both)
  end

  def declaration
    dgfip_action(request_type: :declaration)
  end

  def dictionnaire
    dgfip_action(request_type: :dictionary)
  end

  private

  def dgfip_action(request_type:)
    retriever_liasse_fiscale = SIADE::V2::Retrievers::LiassesFiscalesDGFIP.new(retriever_params.merge(request_type: request_type))
    retriever_liasse_fiscale.retrieve

    if retriever_liasse_fiscale.success?
      render json: retriever_liasse_fiscale.response, status: 200
    else
      render_errors(retriever_liasse_fiscale)
    end
  end

  def resource_scope
    :liasse_fiscale
  end

  def retriever_params
    retriever_params = params.permit(:siren, :annee)
    retriever_params[:cookie]  = dgfip_service.cookie
    retriever_params[:user_id] = UserIdDGFIPService.call(@authenticated_user.id)

    retriever_params
  end
end
