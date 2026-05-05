class APIParticulier::OpenAPIController < APIParticulierController
  def show
    render plain: yaml_content, content_type: 'application/x-yaml'
  end

  private

  def yaml_content
    definition = APIParticulier::OpenAPIDefinition.instance
    if params[:provider].present?
      definition.open_api_filtered_by_provider_definition_content(params[:provider])
    else
      definition.open_api_v3_definition_content
    end
  end
end
