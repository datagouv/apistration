require_relative '../provider_stubs'

module ProviderStubs::OPQIBI
  def stub_opqibi_valid_siren(siren: valid_siren(:opqibi_with_probatoire))
    stub_request(:get, "#{Siade.credentials[:opqibi_domain]}/certificats/#{siren}")
      .to_return(status: 200, body: read_payload_file('opqibi/certifications_ingenierie/valid_siren.json'))
  end

  def stub_opqibi_not_found_siren(siren: not_found_siren)
    stub_request(:get, "#{Siade.credentials[:opqibi_domain]}/certificats/#{siren}")
      .to_return(status: 404, body: read_payload_file('opqibi/certifications_ingenierie/not_found_siren.html'))
  end
end
