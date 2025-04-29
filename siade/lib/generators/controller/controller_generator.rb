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

  class_option :controller_type,
    type: :string,
    default: nil,
    desc: 'Controller type: civility or france_connect'

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_controller
    case controller_type
    when 'civility'
      template 'controller_with_civility.rb.erb', File.join("app/controllers/api_#{api}/v3_and_more", provider_namespace.underscore, "#{resource_class.underscore}_with_civility_controller.rb")
    when 'france_connect'
      template 'controller_with_france_connect.rb.erb', File.join("app/controllers/api_#{api}/v3_and_more", provider_namespace.underscore, "#{resource_class.underscore}_with_france_connect_controller.rb")
    else
      template 'controller.rb.erb', File.join("app/controllers/api_#{api}/v3_and_more", provider_namespace.underscore, "#{resource_class.underscore}_controller.rb")
    end
  end

  private

  def prochainement?
    options[:prochainement]
  end

  def controller_type
    options[:controller_type]
  end

  def civility?
    options[:validation_type]&.downcase == 'civility' || controller_type == 'civility'
  end
end
