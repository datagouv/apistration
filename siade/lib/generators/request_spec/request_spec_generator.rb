class RequestSpecGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  class_option :validation_type,
    type: :string,
    default: 'siren',
    desc: 'Does the API needs to validate: siren, siret or custom ?'

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_request_spec
    template 'request_spec.rb.erb', File.join('spec/requests/api/v3_and_more/', provider_namespace.underscore, resource_class.underscore, 'v3_spec.rb')
  end

  private

  def id_path_param
    options[:validation_type].downcase
  end

  def document_resource?
    options[:document]
  end
end
