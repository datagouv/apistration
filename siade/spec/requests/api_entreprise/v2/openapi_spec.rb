RSpec.describe 'openapi file', type: :request, api: :entreprise do
  it 'returns the cors header with Origin' do
    get '/v2/openapi.yaml'
    expect(response).to have_http_status(:ok)
  end
end
