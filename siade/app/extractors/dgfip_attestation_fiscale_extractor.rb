class DGFIPAttestationFiscaleExtractor < PDFExtractor
  def extract
    {
      valid:,
      error:
    }.compact
  end

  private

  def valid
    @valid ||= first_page.text.exclude?('Impossible de délivrer votre attestation de régularité fiscale')
  end

  def error
    return if valid

    :not_delivered
  end

  def first_page
    pdf_reader.pages.first
  end
end
