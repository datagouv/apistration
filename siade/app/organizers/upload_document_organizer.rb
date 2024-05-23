class UploadDocumentOrganizer < ApplicationOrganizer
  include ResourceHelpers

  def self.inherited(klass)
    klass.class_eval do
      before do
        context.content = source_file_content
        context.file_type = file_type
        context.filename = filename
      end

      around do |interactor|
        interactor.call unless clogged_env?
      end
    end
  end

  protected

  def source_file_content
    fail NotImplementedError
  end

  def file_type
    fail NotImplementedError
  end

  def filename
    fail NotImplementedError
  end
end
