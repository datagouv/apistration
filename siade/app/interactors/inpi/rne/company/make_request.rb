class INPI::RNE::Company::MakeRequest < INPI::RNE::MakeRequest
  def request_uri
    URI("#{Siade.credentials[:inpi_rne_url]}/api/companies/#{siren}")
  end
end
