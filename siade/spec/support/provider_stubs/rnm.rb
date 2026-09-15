require_relative '../provider_stubs'

module ProviderStubs::RNM
  def stub_rnm_valid_siren(siren: valid_siren(:rnm_cma))
    stub_request(:get, "#{Siade.credentials[:rnm_domain]}/v2/entreprises/#{siren}")
      .with(query: { format: 'json' })
      .to_return(status: 200, body: read_payload_file('rnm/entreprises_artisanales/valid_siren.json'))
  end

  def stub_rnm_not_found_siren(siren: not_found_siren(:rnm_cma))
    stub_request(:get, "#{Siade.credentials[:rnm_domain]}/v2/entreprises/#{siren}")
      .with(query: { format: 'json' })
      .to_return(status: 404, body: read_payload_file('rnm/entreprises_artisanales/not_found_siren.html'))
  end
end
