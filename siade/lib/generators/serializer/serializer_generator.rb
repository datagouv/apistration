class SerializerGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  class_option :document,
    type:    :boolean,
    default: false,
    desc:    'Add support of documents uploader'

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_serialiazer
    template 'serializer.rb.erb', File.join('app/serializers', provider_namespace.underscore, resource_class.underscore, 'v3.rb')
  end

  private

  def document_resource?
    options[:document]
  end
end
