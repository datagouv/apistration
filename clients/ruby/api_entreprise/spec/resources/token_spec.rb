RSpec.describe 'Token introspection' do
  it 'introspects with the token alone, without audit params' do
    stub = stub_request(:get, 'https://staging.entreprise.api.gouv.fr/v3/token/introspect')
           .to_return(status: 200, headers: { 'Content-Type' => 'application/json' },
                      body: { data: {}, links: {}, meta: {} }.to_json)
    ApiEntreprise::Client.new(token: 't', environment: :staging).token.introspect
    expect(stub).to have_been_requested
  end
end
