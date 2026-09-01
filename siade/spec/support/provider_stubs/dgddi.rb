require_relative '../provider_stubs'

module ProviderStubs::DGDDI
  def stub_dgddi_valid_eori(eori: valid_eori)
    stub_request(:get, "#{Siade.credentials[:douanes_domain]}/#{eori}")
      .with(query: { idClient: Siade.credentials[:douanes_client_id] })
      .to_return(status: 200, body: read_payload_file('dgddi/eori/valid_eori.json'))
  end

  def stub_dgddi_valid_spanish_eori(eori: valid_spanish_eori)
    stub_request(:get, "#{Siade.credentials[:douanes_domain]}/#{eori}")
      .with(query: { idClient: Siade.credentials[:douanes_client_id] })
      .to_return(status: 200, body: read_payload_file('dgddi/eori/valid_spanish_eori.json'))
  end

  def stub_dgddi_invalid_eori_format(eori: invalid_eori)
    stub_request(:get, "#{Siade.credentials[:douanes_domain]}/#{eori}")
      .with(query: { idClient: Siade.credentials[:douanes_client_id] })
      .to_return(status: 400, body: read_payload_file('dgddi/eori/invalid_eori_format.json'))
  end

  def stub_dgddi_non_existing_eori(eori: non_existing_eori)
    stub_request(:get, "#{Siade.credentials[:douanes_domain]}/#{eori}")
      .with(query: { idClient: Siade.credentials[:douanes_client_id] })
      .to_return(status: 404, body: read_payload_file('dgddi/eori/non_existing_eori.json'))
  end
end
