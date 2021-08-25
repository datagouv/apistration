class ValidateResponseGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_validate_response
    template 'validate_response.rb.erb', File.join('app/interactors', provider_namespace.underscore, resource_class.underscore, 'validate_response.rb')
    template 'validate_response_spec.rb.erb', File.join('spec/interactors', provider_namespace.underscore, resource_class.underscore, 'validate_response_spec.rb')
  end
end
