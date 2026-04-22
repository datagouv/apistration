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
    endpoint_files.each_with_object({}) do |file, result|
      data = YAML.safe_load_file(file, aliases: true)
      fiches = [*data['fiche']]
      fiches.each do |fiche|
        next unless fiche['swagger']

        result.deep_merge!(fiche['swagger'])
      end
    end
  end

  def shared_files
    Dir.glob('config/swagger_data/**/*.{yml,yaml}')
  end

  def endpoint_files
    Dir.glob('config/endpoints/api_*/**/*.yml')
  end
end
