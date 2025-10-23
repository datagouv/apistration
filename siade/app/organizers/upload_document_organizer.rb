class UploadDocumentOrganizer < ApplicationOrganizer
  include ResourceHelpers

  # rubocop:disable Metrics/AbcSize
  def self.inherited(klass)
    klass.class_eval do
      before do
        context.content = source_file_content
        context.file_type = file_type
        context.filename = filename
        context.expires_in = expires_in
      end

      around do |interactor|
        interactor.call unless use_mocked_data?
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

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

  def expires_in
    1.day.to_i
  end
end
