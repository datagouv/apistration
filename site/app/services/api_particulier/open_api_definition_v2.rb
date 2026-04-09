class APIParticulier::OpenAPIDefinitionV2 < APIParticulier::OpenAPIDefinition
  protected

  def local_path
    Rails.root.join('config/api-particulier-openapi.yml')
  end
end
