require_relative '../provider_stubs'

module ProviderStubs::DataSubvention
  def stub_datasubvention_subventions_authenticate
    stub_request(:post, "#{Siade.credentials[:data_subvention_url]}/auth/login")
      .with(
        headers: {
          'accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
      )
      .to_return(
        status: 200,
        body: read_payload_file('data_subvention/subventions/authenticate.json')
      )
  end

  def stub_datasubvention_subventions_valid(id: valid_siren, token: 'data_subvention_token')
    stub_request(:get, "#{Siade.credentials[:data_subvention_url]}/association/#{id}/grants")
      .with(
        headers: {
          'x-access-token' => token,
          'Content-Type' => 'application/json'
        }
      )
      .to_return(
        status: 200,
        body: read_payload_file('data_subvention/subventions/valid.json')
      )
  end
end
