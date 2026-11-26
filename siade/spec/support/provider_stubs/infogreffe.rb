require_relative '../provider_stubs'

module ProviderStubs::Infogreffe
  def stub_infogreffe_extrait_rcs(siren:, payload:)
    stub_request(:post, Siade.credentials[:infogreffe_url_extrait_rcs])
      .with { |request| request.body.include?("<num_siren>#{siren}</num_siren>") && request.body.exclude?('version_schema') }
      .to_return(
        status: 200,
        body: open_payload_file("infogreffe/#{payload}.xml").read
      )
  end

  def stub_infogreffe_extrait_rcs_schema_14(siren:, payload:)
    stub_request(:post, Siade.credentials[:infogreffe_url_extrait_rcs])
      .with(body: %r{<version_schema>14</version_schema>.*<num_siren>#{siren}</num_siren>}m)
      .to_return(
        status: 200,
        body: open_payload_file("infogreffe/schema_14/#{payload}.xml").read
      )
  end
end
