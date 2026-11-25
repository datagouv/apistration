require_relative '../provider_stubs'

module ProviderStubs::Infogreffe
  def stub_infogreffe_extrait_rcs(siren:, payload:)
    stub_request(:post, Siade.credentials[:infogreffe_url_extrait_rcs])
      .with(body: %r{<num_siren>#{siren}</num_siren>})
      .to_return(
        status: 200,
        body: open_payload_file("infogreffe/#{payload}.xml").read
      )
  end
end
