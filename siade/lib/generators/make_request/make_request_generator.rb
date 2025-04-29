class MakeRequestGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  class_option :verb,
    type: :string,
    default: 'GET',
    desc: 'HTTP request verb (GET or POST)'

  class_option :validation_type,
    type: :string,
    default: 'siren',
    desc: 'Does the API needs to validate: siren, siret or custom ?'

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_make_request
    template 'make_request.rb.erb', File.join('app/interactors', provider_namespace.underscore, resource_class.underscore, 'make_request.rb')
    template 'make_request_spec.rb.erb', File.join('spec/interactors', provider_namespace.underscore, resource_class.underscore, 'make_request_spec.rb')
  end

  private

  def get_request?
    options[:verb].upcase == 'GET'
  end

  def civility_validation?
    options[:validation_type]&.downcase == 'civility'
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
end
