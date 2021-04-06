class UploadDocumentOrganizer < ApplicationOrganizer
  include ResourceHelpers

  def self.inherited(klass)
    klass.class_eval do
      before do
        context.content = source_file_content
        context.file_type = file_type
        context.filename = filename
      end
    end
  end

  protected

  def source_file_content
    fail 'should be implemented in inherited class'
  end

  def file_type
    fail 'should be implemented in inherited class'
  end

  def filename
    fail 'should be implemented in inherited class'
  end
end
