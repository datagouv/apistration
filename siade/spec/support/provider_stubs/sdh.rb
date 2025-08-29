require_relative '../provider_stubs'

module ProviderStubs::SDH
  def stub_sdh_authenticate
    stub_request(:post, Siade.credentials[:sdh_authenticate_url]).with(
      body: {
        'client_id' => Siade.credentials[:sdh_client_id],
        'client_secret' => Siade.credentials[:sdh_client_secret],
        'grant_type' => 'client_credentials'
      }
    ).to_return(
      status: 200,
      body: {
        token_type: 'Bearer',
        expires_in: 3600,
        access_token: 'super_sdh_access_token'
      }.to_json
    )
  end

  def stub_sdh_statut_sportif_valid(identifiant)
    stub_request(:get, "#{Siade.credentials[:sdh_endpoint_url]}/#{identifiant}").to_return(
      status: 200,
      body: read_payload_file('sdh/statut_sportif/found.json')
    )
  end

  def stub_sdh_statut_sportif_not_found(identifiant)
    stub_request(:get, "#{Siade.credentials[:sdh_endpoint_url]}/#{identifiant}").to_return(
      status: 404,
      body: nil
    )
  end
end
