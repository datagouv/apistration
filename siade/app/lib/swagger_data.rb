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
    @yaml_backend ||= load_shared.deep_merge(load_from_endpoints)
  end

  def load_shared
    raw = shared_files.sort.map { |f| "#{File.read(f)}\n" }.reduce(:+)
    return {} unless raw

    YAML.safe_load(ERB.new(raw).result, permitted_classes: [Date], aliases: true) || {}
  end

  def load_from_endpoints
    prefix = shared_raw
    exclude = load_shared.keys + ['fiche']
    endpoint_files.inject({}) do |result, file|
      content = File.read(file).sub(/\A---\n/, '')
      raw = "#{prefix}\n#{content}"
      data = YAML.safe_load(raw, permitted_classes: [Date], aliases: true)
      swagger_keys = data.except(*exclude)
      next result if swagger_keys.empty?

      result.deep_merge(swagger_keys)
    end
  end

  def shared_raw
    @shared_raw ||= shared_files.sort.map { |f| "#{File.read(f)}\n" }.reduce(:+) || ''
  end

  def shared_files
    Dir.glob('config/swagger_data/**/*.{yml,yaml}')
  end

  def endpoint_files
    Dir.glob('config/endpoints/api_*/**/*.yml')
  end
end
