class APIEntreprise::OpenAPIController < APIEntrepriseController
  def show
    render plain: yaml_content, content_type: 'application/x-yaml'
  end

  private

  def yaml_content
    definition = APIEntreprise::OpenAPIDefinition.instance
    if params[:provider].present?
      definition.open_api_filtered_by_provider_definition_content(params[:provider])
    else
      definition.open_api_definition_content
    end
  end
end
