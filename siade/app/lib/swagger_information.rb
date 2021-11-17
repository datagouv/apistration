require 'erb'

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
    @yaml_backend ||= YAML.safe_load(yaml_backend_interpolated, [], [], true)
  end

  def yaml_backend_interpolated
    ERB.new(File.read(yaml_backend_path)).result
  end

  def yaml_backend_path
    Rails.root.join('config/swagger_information.yml')
  end
end
