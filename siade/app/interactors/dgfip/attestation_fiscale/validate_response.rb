class DGFIP::AttestationFiscale::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found? || pdf_not_delivered?
    unknown_provider_response! if !http_ok? || !body_is_a_pdf?
  end

  private

  def pdf_not_delivered?
    extract = DGFIPAttestationFiscaleExtractor.new(context.response.body).perform

    return true if !extract[:valid] && extract[:error] == :not_delivered

    false
  rescue PDFExtractor::InvalidFile
    false
  end

  def body_is_a_pdf?
    body_mime_type == 'application/pdf'
  end

  def body_mime_type
    Marcel::MimeType.for(context.response.body)
  end
end
