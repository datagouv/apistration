require_relative '../provider_stubs'

module ProviderStubs::MESRI
  def mock_mesri_scolarite_auth
    stub_request(:post, Siade.credentials[:mesri_scolarite_authenticate_url]).to_return(
      status: 200,
      body: open_payload_file('mesri/scolarites/authenticate.json')
    )
  end

  def mock_mesri_scolarite
    stub_request(:get, /#{Siade.credentials[:mesri_scolarite_url]}/).to_return(
      status: 200,
      body: open_payload_file('mesri/scolarites/valid.json')
    )
  end
end
