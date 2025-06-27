class INPI::RNE::ExtraitDownload::MakeRequest < INPI::RNE::MakeRequest
  def request_uri
    URI("https://data.inpi.fr/export/companies?format=pdf&ids=[\"#{siren}\"]")
  end

  def siren
    context.params[:siren]
  end
end
