require 'singleton'

class RouteScopesStore
  include Singleton

  def self.scopes_for(controller)
    instance.index[controller] || []
  end

  def self.scopes_for_controllers(controllers)
    controllers.flat_map { |controller| scopes_for(controller) }.uniq
  end

  def index
    load_index if Rails.env.development?
    @index
  end

  private

  def initialize
    load_index
    super
  end

  def load_index
    config = YAML.safe_load_file(Rails.root.join('config/route_scopes.yml'), aliases: true)
    @index = (config['shared'] || {}).transform_values { |scopes| Array(scopes) }
  end
end
