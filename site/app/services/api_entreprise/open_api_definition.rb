class APIEntreprise::OpenAPIDefinition < AbstractOpenAPIDefinition
  protected

  def local_path
    Rails.root.join('config/api-entreprise-v3-openapi.yml')
  end
end
