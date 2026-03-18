class SIADE::SelfHostedDocument::FormatValidator
  def initialize(type)
    @type = type
  end

  def valid?(content)
    mime = extract_mime_type(content)
    mime.eql?("application/#{@type}")
  end

  private

  def extract_mime_type(value)
    Marcel::MimeType.for(value)
  end
end
