require 'erb'

class SwaggerData
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
    @yaml_backend ||= YAML.safe_load(yaml_backend_interpolated, aliases: true)
  end

  def yaml_backend_interpolated
    ERB.new(yaml_backend_raw).result
  end

  def yaml_backend_raw
    yaml_files = Dir.glob('config/swagger_data/**/*')

    yaml_files.map { |file_path| "#{File.read(file_path)}\n" }.reduce(:+)
  end
end
