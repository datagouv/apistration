class ValidateParamsGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_validate_params
    template 'validate_params.rb.erb', File.join('app/organizers', provider_namespace.underscore, resource_class.underscore, 'validate_params.rb')
    template 'validate_params_spec.rb.erb', File.join('spec/organizers', provider_namespace.underscore, resource_class.underscore, 'validate_params_spec.rb')
  end
end
