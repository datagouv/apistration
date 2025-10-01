class APIEntrepriseSwaggerData
  include Singleton

  attr_reader :swagger

  def initialize
    @swagger = YAML.load_file(Rails.root.join('swagger/openapi-entreprise.yaml'))
  end
end
