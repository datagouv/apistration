class BuildResourceGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  class_option :document,
    type: :boolean,
    default: false,
    desc: 'Does the API returns some documents?'

  class_option :validation_type,
    type: :string,
    default: 'siren',
    desc: 'Does the API needs to validate: siren, siret or custom?'

  class_option :is_collection,
    type: :boolean,
    default: false,
    desc: 'Is the payload a collection or a single resource?'

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_build_resource
    if build_collection?
      create_build_resource_collection
    else
      create_build_resource_single
    end
  end

  private

  def create_build_resource_single
    template 'build_resource.rb.erb', File.join('app/interactors', provider_namespace.underscore, resource_class.underscore, 'build_resource.rb')
    template 'build_resource_spec.rb.erb', File.join('spec/interactors', provider_namespace.underscore, resource_class.underscore, 'build_resource_spec.rb')
  end

  def create_build_resource_collection
    template 'build_resource_collection.rb.erb', File.join('app/interactors', provider_namespace.underscore, resource_class.underscore, 'build_resource_collection.rb')
    template 'build_resource_collection_spec.rb.erb', File.join('spec/interactors', provider_namespace.underscore, resource_class.underscore, 'build_resource_collection_spec.rb')
  end

  def id_name
    return if options[:validation_type].nil?

    case options[:validation_type].downcase
    when 'siren'
      'siren'
    when 'siret'
      'siret'
    end
  end

  def document_resource?
    options[:document]
  end

  def build_collection?
    options[:is_collection]
  end
end
