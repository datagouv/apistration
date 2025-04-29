class SerializerGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  class_option :document,
    type: :boolean,
    default: false,
    desc: 'Add support of documents uploader'

  class_option :api_kind,
    type: :string,
    default: 'entreprise',
    desc: 'Which product ?'

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_serializer
    template 'serializer.rb.erb', File.join("app/serializers/api_#{api}/", provider_namespace.underscore, "#{resource_class.underscore}_serializer", 'v3.rb')
  end

  private

  def document_resource?
    options[:document]
  end
end
