class PolicyGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_policy
    template 'policy.rb.erb', File.join('app/policies', "#{resource_class.underscore}_policy.rb")
    template 'policy_spec.rb.erb', File.join('spec/policies', "#{resource_class.underscore}_policy_spec.rb")
  end
end
