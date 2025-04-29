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

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_request_spec
    template 'request_spec.rb.erb', File.join("spec/requests/api_#{api}/v3_and_more/", provider_namespace.underscore, resource_class.underscore, 'v3_spec.rb')
  end

  private

  def params
    options[:validation_type].downcase
  end
  
  def civility_validation?
    options[:validation_type].downcase == 'civility'
  end

  def document_resource?
    options[:document]
  end

  def prochainement?
    options[:prochainement]
  end
end
