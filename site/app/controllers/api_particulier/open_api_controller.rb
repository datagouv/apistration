class APIParticulier::OpenAPIController < APIParticulierController
  def show
    if params[:operation_id].present?
      render plain: APIParticulier::OpenAPIDefinition.instance.open_api_partial_definition_content(Array(params[:operation_id]))
    else
      render plain: APIParticulier::OpenAPIDefinition.instance.open_api_definition_content
    end
  end
end
