require_relative '../provider_stubs'

module ProviderStubs::ANTS
  def stub_ants_authenticate
    stub_request(:post, Siade.credentials[:ants_siv2_token_url])
      .to_return(
        status: 200,
        body: { access_token: 'test_token', expires_in: 7200 }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def stub_ants_extrait_immatriculation_vehicule_valid
    stub_ants_authenticate

    stub_request(:post, Siade.credentials[:ants_siv2_url]).to_return(
      status: 200,
      body: read_payload_file('ants/found.json')
    )
  end

  def stub_ants_extrait_immatriculation_vehicule_not_found
    stub_ants_authenticate

    stub_request(:post, Siade.credentials[:ants_siv2_url]).to_return(
      status: 200,
      body: read_payload_file('ants/not_found.json')
    )
  end

  def stub_ants_extrait_immatriculation_vehicule_identity_mismatch
    stub_ants_authenticate

    stub_request(:post, Siade.credentials[:ants_siv2_url]).to_return(
      status: 200,
      body: read_payload_file('ants/identity_mismatch.json')
    )
  end

  def stub_ants_extrait_immatriculation_vehicule_invalid(status:)
    stub_ants_authenticate

    stub_request(:post, Siade.credentials[:ants_siv2_url]).to_return(
      status:
    )
  end
end
