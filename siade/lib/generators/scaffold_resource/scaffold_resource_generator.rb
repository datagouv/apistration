class ScaffoldResourceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  class_option :api_kind,
    type: :string,
    default: 'entreprise',
    desc: 'Which product ?',
    enum: %w[entreprise particulier]

  class_option :document,
    type: :boolean,
    default: false,
    desc: 'Add support of documents uploader'

  class_option :validation_type,
    type: :string,
    default: 'siren',
    desc: 'Which params will be used for the endpoint and need validation',
    enum: %w[siren siret custom civility]

  class_option :verb,
    type: :string,
    default: 'GET',
    desc: 'HTTP request verb',
    enum: %w[GET POST]

  class_option :is_collection,
    type: :boolean,
    default: false,
    desc: 'Is the payload a collection or a single resource?'

  class_option :prochainement,
    type: :boolean,
    default: false,
    desc: 'Prepare the documentation and staging without a working API'

  class_option :with_france_connect,
    type: :boolean,
    default: false,
    desc: 'Add additional controller with France Connect support'

  def create_scaffold_resource
    if options[:validation_type]&.downcase == 'civility'
      generate 'controller', name, string_options.gsub('--validation_type=civility', '--controller_type=civility')
      generate 'request_spec', name, string_options.gsub('--validation_type=civility', '--controller_type=civility')
    else
      generate 'controller', name, string_options
      generate 'request_spec', name, string_options
    end

    # Generate an additional FranceConnect controller if requested
    if options[:with_france_connect] && options[:api_kind] == 'particulier'
      generate 'controller', name, string_options.gsub('--with_france_connect=true', '--controller_type=france_connect')
      generate 'request_spec', name, string_options.gsub('--with_france_connect=true', '--controller_type=france_connect')
    end

    generate 'retriever', name, string_options
    generate 'validate_params', name, string_options if custom_validation?
    generate 'serializer', name, string_options
    generate 'make_request', name, string_options

    return if prochainement?

    generate 'upload_document', name, string_options if document_resource?
    generate 'validate_response', name, string_options
    generate 'build_resource', name, string_options
  end

  private

  def string_options
    options.map { |k, v| "--#{k}=#{v}" }.join(' ')
  end

  def document_resource?
    options[:document]
  end

  def prochainement?
    options[:prochainement]
  end

  def get_request?
    options[:verb].upcase == 'GET'
  end

  def custom_validation?
    options[:validation_type].downcase == 'custom'
  end
end
