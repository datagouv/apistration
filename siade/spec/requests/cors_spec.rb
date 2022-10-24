RSpec.describe 'Cors' do
  before do
    host! 'entreprise.api.localtest.me'
  end

  it 'reject Cors policy for example.com for any resource' do
    get '/v2/ping', params: {}, headers: { Origin: 'http://example.com' }
    expect(response.header).not_to have_key('Access-Control-Allow-Origin')
  end

  it 'allows localhost for the Swagger v2 file' do
    get '/v2/openapi.yaml', params: {}, headers: { Origin: 'http://localhost:3000' }
    expect(response.header).to have_key('Access-Control-Allow-Origin')
  end

  it 'allows localhost for the Swagger v3 file' do
    get '/v3/openapi.yaml', params: {}, headers: { Origin: 'http://localhost:3000' }
    expect(response.header).to have_key('Access-Control-Allow-Origin')
  end
end
