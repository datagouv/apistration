class Documents::ValidateFormat < ApplicationInteractor
  before do
    context.errors ||= []
  end

  def call
    unless valid_format?
      errors << "File content is not in the expected `#{context.file_type}` format."
      context.fail!
    end
  end

  def valid_format?
    mime.eql?("application/#{context.file_type}")
  end

  def mime
    @mime ||= Marcel::MimeType.for(context.content)
  end

  def errors
    context.errors
  end
end
