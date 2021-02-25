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
    !mime.nil? && mime.child_of?("application/#{context.file_type}")
  end

  def mime
    @mime ||= MimeMagic.by_magic(context.content)
  end

  def errors
    context.errors
  end
end
