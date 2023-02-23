require_relative '../provider_stubs'

module ProviderStubs::URSSAF
  def mock_urssaf_authenticate
    stub_request(:post, "#{Siade.credentials[:acoss_domain]}/api/oauth/v1/token").and_return(
      status: 200,
      body: {
        access_token: 'access_token',
        expires_in: 3600,
        token_type: 'Bearer'
      }.to_json
    )
  end

  def mock_valid_urssaf_attestation_sociale(access_token = 'access_token', &block)
    stub_request(:post, "#{Siade.credentials[:acoss_domain]}/attn/entreprise/v1/demandes/api_entreprise").with(
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{access_token}"
      }
    ).and_return(
      status: 200,
      body: block.call
    )
  end
end
