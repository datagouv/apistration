class APIParticulier::OpenAPIDefinition < AbstractOpenAPIDefinition
  def open_api_v3_definition_content
    Rails.root.join('config/api-particulier-openapi-v3.yml').read
  end

  def open_api_v2_definition_content
    Rails.root.join('config/api-particulier-openapi.yml').read
  end

  protected

  def local_path
    Rails.root.join('config/api-particulier-openapi-v3.yml')
  end
end
