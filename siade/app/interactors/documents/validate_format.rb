class Documents::ValidateFormat < ApplicationInteractor
  before do
    context.errors ||= []
  end

  def call
    return if valid_format?

    errors << BadFileFromProviderError.new(context.provider_name, :invalid_extension, "File content is not in the expected `#{context.file_type}` format.")
    context.fail!
  end

  def valid_format?
    mime.eql?("application/#{context.file_type}")
  end

  def mime
    @mime ||= Marcel::MimeType.for(context.content)
  end

  delegate :errors, to: :context
end
