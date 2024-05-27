class SIADE::SelfHostedDocument::File::PDF < SIADE::SelfHostedDocument::File::Generic
  attr_reader :decrypt

  def initialize(*, decrypt: false)
    @decrypt = decrypt
    super(*)
  end

  def perform
    @binary = SIADE::SelfHostedDocument::PDFDecrypt.new(@binary).call if decrypt
    super
  end

  def file_extension
    'pdf'
  end
end
