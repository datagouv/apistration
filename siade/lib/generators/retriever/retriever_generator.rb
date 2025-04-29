class RetrieverGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  class_option :document,
    type: :boolean,
    default: false,
    desc: 'Add support of documents uploader'

  class_option :validation_type,
    type: :string,
    default: 'siren',
    desc: 'Does the API needs to validate: siren, siret or custom ?'

  class_option :is_collection,
    type: :boolean,
    default: false,
    desc: 'Is the payload a collection or a single resource?'

  class_option :prochainement,
    type: :boolean,
    default: false,
    desc: 'Prepare the documentation and staging without a working API'

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_retriever
    template 'retriever.rb.erb', File.join('app/organizers', provider_namespace.underscore, "#{resource_class.underscore}.rb")
    template 'retriever_spec.rb.erb', File.join('spec/organizers', provider_namespace.underscore, "#{resource_class.underscore}_spec.rb")
  end

  private

  def civility_validation?
    options[:validation_type]&.downcase == 'civility'
  end

  def document_resource?
    options[:document]
  end

  def prochainement?
    options[:prochainement]
  end

  def validation_class
    case options[:validation_type].downcase
    when 'siren'
      'ValidateSiren'
    when 'siret'
      'ValidateSiret'
    else
      "#{name}::ValidateParams"
    end
  end
end
