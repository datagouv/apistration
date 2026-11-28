class PDFExtractor
  class InvalidFile < StandardError; end

  attr_reader :pdf_content

  def initialize(pdf_content)
    @pdf_content = pdf_content
  end

  def self.initialize_with_reader(pdf_reader)
    instance = new(nil)
    instance.instance_variable_set(:@pdf_reader, pdf_reader)
    instance
  end

  def perform
    extract
  rescue PDF::Reader::MalformedPDFError
    raise InvalidFile
  rescue NoMethodError => e
    raise InvalidFile if raised_by_pdf_reader?(e)

    raise
  end

  protected

  def extract
    raise NotImplementedError
  end

  def pages
    @pages ||= pdf_reader.pages
  end

  private

  def raised_by_pdf_reader?(error)
    error.backtrace_locations.first.path.start_with?(Gem.loaded_specs['pdf-reader'].full_gem_path)
  end

  def pdf_reader
    @pdf_reader ||= PDF::Reader.new(StringIO.new(pdf_content))
  end
end
