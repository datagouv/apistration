RSpec.describe 'Ping', type: :request do
  it 'returns 200' do
    get '/v3/ping'
    expect(response).to have_http_status(:ok)
  end
end
