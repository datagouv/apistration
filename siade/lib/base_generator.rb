require 'rails/generators'

class BaseGenerator < Rails::Generators::NamedBase
  private

  def provider_namespace
    name.split('::')[0]
  end

  def resource_class
    name.split('::')[1]
  end

  def api
    if api_kind_missing?
      'entreprise'
    else
      options[:api_kind]
    end
  end

  def api_kind_missing?
    options[:api_kind].is_a?(TrueClass) ||
      options[:api_kind].blank?
  end
end
