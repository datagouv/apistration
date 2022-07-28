class ScaffoldResourceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  class_option :document,
    type: :boolean,
    default: false,
    desc: 'Add support of documents uploader'

  class_option :validation_type,
    type: :string,
    default: 'siren',
    desc: 'Does the API needs to validate: siren, siret or custom ?'

  class_option :verb,
    type: :string,
    default: 'GET',
    desc: 'HTTP request verb (GET or POST)'

  class_option :is_collection,
    type: :boolean,
    default: false,
    desc: 'Is the payload a collection or a single resource?'

  def create_scaffold_resource
    generate 'controller', name, string_options
    generate 'serializer', name, string_options
    generate 'retriever', name, string_options
    generate 'validate_params', name, string_options if custom_validation?
    generate 'upload_document', name, string_options if document_resource?
    generate 'make_request', name, string_options
    generate 'validate_response', name, string_options
    generate 'build_resource', name, string_options
    generate 'request_spec', name, string_options
  end

  private

  def string_options
    options.map { |k, v| "--#{k}=#{v}" }.join(' ')
  end

  def document_resource?
    options[:document]
  end

  def get_request?
    options[:verb].upcase == 'GET'
  end

  def custom_validation?
    options[:validation_type].downcase == 'custom'
  end
end
