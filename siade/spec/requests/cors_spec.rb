RSpec.describe 'Cors', type: :request do
  it 'allows localhost for the Swagger v2 file' do
    get '/v2/openapi.yaml', params: {}, headers: { Origin: 'http://localhost:3000' }
    expect(response.header).to have_key('Access-Control-Allow-Origin')
  end

  it 'allows localhost for the Swagger v3 file' do
    get '/v3/openapi.yaml', params: {}, headers: { Origin: 'http://localhost:3000' }
    expect(response.header).to have_key('Access-Control-Allow-Origin')
  end
end
