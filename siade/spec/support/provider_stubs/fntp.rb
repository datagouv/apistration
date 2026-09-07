require_relative '../provider_stubs'

module ProviderStubs::FNTP
  def stub_fntp_valid_siren(siren: valid_siren(:fntp))
    stub_request(:get, "#{Siade.credentials[:fntp_domain]}/rip/sgmap/#{siren}/cartepro")
      .with(query: { token: Siade.credentials[:fntp_token] })
      .to_return(
        status: 200,
        body: Rails.root.join('spec/fixtures/pdfs/fntp_carte_professionnelle_travaux_publics/valid_siren.pdf').read,
        headers: { 'Content-Type' => 'application/pdf' }
      )
  end

  def stub_fntp_not_found_siren(siren: not_found_siren)
    stub_request(:get, "#{Siade.credentials[:fntp_domain]}/rip/sgmap/#{siren}/cartepro")
      .with(query: { token: Siade.credentials[:fntp_token] })
      .to_return(status: 404, body: '', headers: { 'Content-Type' => 'text/plain' })
  end
end
