class MakeRequestGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  class_option :verb,
    type: :string,
    default: 'GET',
    desc: 'HTTP request verb (GET or POST)'

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_make_request
    template 'make_request.rb.erb', File.join('app/interactors', provider_namespace.underscore, resource_class.underscore, 'make_request.rb')
    template 'make_request_spec.rb.erb', File.join('spec/interactors', provider_namespace.underscore, resource_class.underscore, 'make_request_spec.rb')
  end

  private

  def get_request?
    options[:verb].upcase == 'GET'
  end
end
