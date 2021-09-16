require 'rails/generators'

class BaseGenerator < Rails::Generators::NamedBase
  private

  def provider_namespace
    name.split('::')[0]
  end

  def resource_class
    name.split('::')[1]
  end
end
