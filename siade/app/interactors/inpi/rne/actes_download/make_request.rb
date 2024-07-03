class INPI::RNE::ActesDownload::MakeRequest < INPI::RNE::MakeRequest
  def request_uri
    URI("#{Siade.credentials[:inpi_rne_url]}/api/actes/#{document_id}/download")
  end

  def document_id
    context.params[:document_id]
  end
end
