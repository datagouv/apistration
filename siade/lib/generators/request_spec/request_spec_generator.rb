class RequestSpecGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  class_option :api_kind,
    type: :string,
    default: 'entreprise',
    desc: 'Which product ?'

  class_option :validation_type,
    type: :string,
    default: 'siren',
    desc: 'Does the API needs to validate: siren, siret or custom ?'

  class_option :prochainement,
    type: :boolean,
    default: false,
    desc: 'Prepare the documentation and staging without a working API'

  class_option :controller_type,
    type: :string,
    default: nil,
    desc: 'Controller type: civility or france_connect'

  class_option :with_france_connect,
    type: :boolean,
    default: false,
    desc: 'Add additional spec with France Connect support'

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_request_spec
    case controller_type
    when 'civility'
      template 'request_spec_with_civility.rb.erb', File.join("spec/requests/api_#{api}/v3_and_more/", provider_namespace.underscore, resource_class.underscore, "#{resource_class.underscore}_with_civility_spec.rb")
    when 'france_connect'
      template 'request_spec_with_france_connect.rb.erb', File.join("spec/requests/api_#{api}/v3_and_more/", provider_namespace.underscore, resource_class.underscore, "#{resource_class.underscore}_with_france_connect_spec.rb")
    else
      template 'request_spec.rb.erb', File.join("spec/requests/api_#{api}/v3_and_more/", provider_namespace.underscore, resource_class.underscore, 'v3_spec.rb')

      # Generate an additional France Connect spec if requested
      template 'request_spec_with_france_connect.rb.erb', File.join("spec/requests/api_#{api}/v3_and_more/", provider_namespace.underscore, resource_class.underscore, "#{resource_class.underscore}_with_france_connect_spec.rb") if options[:with_france_connect] && options[:api_kind] == 'particulier'
    end
  end

  private

  def params
    options[:validation_type].downcase
  end

  def civility_validation?
    options[:validation_type].downcase == 'civility' || controller_type == 'civility'
  end

  def document_resource?
    options[:document]
  end

  def prochainement?
    options[:prochainement]
  end

  def controller_type
    options[:controller_type]
  end

  def france_connect?
    controller_type == 'france_connect'
  end
end
