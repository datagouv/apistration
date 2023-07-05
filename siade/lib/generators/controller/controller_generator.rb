class ControllerGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  class_option :api_kind,
    type: :string,
    default: 'entreprise',
    desc: 'Which product ?'

  class_option :prochainement,
    type: :boolean,
    default: false,
    desc: 'Prepare the documentation and staging without a working API'

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_controller
    template 'controller.rb.erb', File.join("app/controllers/api_#{api}/v3_and_more", provider_namespace.underscore, "#{resource_class.underscore}_controller.rb")
  end

  def prochainement?
    options[:prochainement]
  end
end
