class INPI::RNE::BilansDownload::MakeRequest < INPI::RNE::MakeRequest
  def request_uri
    URI("#{Siade.credentials[:inpi_rne_url]}/api/bilans/#{document_id}/download")
  end

  def document_id
    context.params[:document_id]
  end
end
