class BuildResourceGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  class_option :document,
    type: :boolean,
    default: false,
    desc: 'Does the API returns some documents ?'

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_build_resource
    template 'build_resource.rb.erb', File.join('app/interactors', provider_namespace.underscore, resource_class.underscore, 'build_resource.rb')
    template 'build_resource_spec.rb.erb', File.join('spec/interactors', provider_namespace.underscore, resource_class.underscore, 'build_resource_spec.rb')
  end

  private

  def document_resource?
    options[:document]
  end
end
