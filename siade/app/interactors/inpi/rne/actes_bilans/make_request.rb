class INPI::RNE::ActesBilans::MakeRequest < INPI::RNE::MakeRequest
  def request_uri
    URI("#{Siade.credentials[:inpi_rne_url]}/api/companies/#{siren}/attachments")
  end
end
