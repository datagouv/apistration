class ControllerGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_controller
    template 'controller.rb.erb', File.join('app/controllers/api/v3_and_more', provider_namespace.underscore, "#{resource_class.underscore}_controller.rb")
  end
end
