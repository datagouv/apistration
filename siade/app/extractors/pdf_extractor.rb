class PDFExtractor
  class InvalidFile < StandardError; end

  attr_reader :pdf_content

  def initialize(pdf_content)
    @pdf_content = pdf_content
  end

  def perform
    extract
  rescue PDF::Reader::MalformedPDFError
    raise InvalidFile
  end

  protected

  def extract
    raise NotImplementedError
  end

  private

  def pdf_reader
    @pdf_reader ||= PDF::Reader.new(StringIO.new(pdf_content))
  end
end
