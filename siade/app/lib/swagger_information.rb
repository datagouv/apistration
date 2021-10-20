class SwaggerInformation
  include Singleton

  def self.get(key)
    instance.get(key)
  end

  def get(key)
    yaml_backend.dig(*key.split('.')) || raise_error(key)
  end

  private

  def raise_error(key)
    raise KeyError, "key not found: #{key}"
  end

  def yaml_backend
    @yaml_backend ||= YAML.load_file(yaml_backend_path)
  end

  def yaml_backend_path
    Rails.root.join('config/swagger_information.yml')
  end
end
