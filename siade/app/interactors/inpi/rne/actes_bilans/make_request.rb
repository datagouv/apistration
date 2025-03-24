class INPI::RNE::ActesBilans::MakeRequest < INPI::RNE::MakeRequest
  def mocking_params
    {
      siren: context.params[:siren]
    }
  end

  def request_uri
    URI("#{Siade.credentials[:inpi_rne_url]}/api/companies/#{siren}/attachments")
  end
end
