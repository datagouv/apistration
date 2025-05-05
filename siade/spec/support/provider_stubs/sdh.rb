require_relative '../provider_stubs'

module ProviderStubs::SDH
  def stub_sdh_authenticate
    stub_request(:get, Siade.credentials[:sdh_authenticate_url])
      .to_return(
        status: 200,
        body: {
          token_type: 'bearer',
          expires_in: 3600,
          access_token: 'super_sdh_access_token'
        }.to_json
      )
  end

  def stub_sdh_statut_sportif_valid
    stub_request(:get, Siade.credentials[:sdh_endpoint_url]).to_return(
      status: 200,
      body: read_payload_file('sdh/statut_sportif/found.json')
    )
  end

  def stub_sdh_statut_sportif_not_found
    stub_request(:get, Siade.credentials[:sdh_endpoint_url]).to_return(
      status: 200,
      body: read_payload_file('sdh/statut_sportif/not_found.json')
    )
  end
end
