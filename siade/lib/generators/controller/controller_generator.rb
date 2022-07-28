class ControllerGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  class_option :is_collection,
    type: :boolean,
    default: false,
    desc: 'Is the payload a collection or a single resource?'

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_controller
    template 'controller.rb.erb', File.join('app/controllers/api_entreprise/v3_and_more', provider_namespace.underscore, "#{resource_class.underscore}_controller.rb")
  end
end
