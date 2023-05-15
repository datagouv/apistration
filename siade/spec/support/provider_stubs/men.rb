require_relative '../provider_stubs'

module ProviderStubs::MEN
  def mock_men_scolarites_auth
    stub_request(:post, Siade.credentials[:men_scolarites_authenticate_url]).to_return(
      status: 200,
      body: open_payload_file('men/scolarites/authenticate.json')
    )
  end

  def mock_men_scolarite
    stub_request(:get, /#{Siade.credentials[:men_scolarites_url]}/).to_return(
      status: 200,
      body: open_payload_file('men/scolarites/valid.json')
    )
  end
end
