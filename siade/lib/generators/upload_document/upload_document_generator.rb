class UploadDocumentGenerator < BaseGenerator
  source_root File.expand_path('templates', __dir__)

  desc 'See `bin/rails generate scaffold_resource --help` instead'
  def create_upload_document
    template 'upload_document.rb.erb', File.join('app/organizers', provider_namespace.underscore, resource_class.underscore, 'upload_document.rb')
    template 'upload_document_spec.rb.erb', File.join('spec/organizers', provider_namespace.underscore, resource_class.underscore, 'upload_document_spec.rb')
  end
end
