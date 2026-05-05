require 'singleton'

class AbstractOpenAPIDefinition
  include Singleton

  attr_reader :backend

  def self.get(path)
    instance.get(path)
  end

  def get(path)
    path = backend['paths'][path]

    return unless path

    path['get']
  end

  def initialize
    load_backend
    super
  end

  def load_backend
    @backend = YAML.safe_load(open_api_definition_content, aliases: true, permitted_classes: [Date])
  end

  def routes
    @routes ||= backend['paths'].keys
  end

  def open_api_without_deprecated_paths_definition_content
    paths = backend['paths'].dup

    paths.reject! do |_, definition|
      definition['get'] &&
        definition['get']['deprecated']
    end

    backend.merge('paths' => paths).to_yaml
  end

  def open_api_definition_content
    local_path.read
  end

  def open_api_filtered_by_provider_definition_content(provider)
    paths = backend['paths'].select { |path, _| path_provider_slug(path) == provider }

    backend.merge('paths' => paths).to_yaml
  end

  protected

  def local_path
    fail NotImplementedError
  end

  private

  def path_provider_slug(path)
    path.split('/')[2]
  end
end
