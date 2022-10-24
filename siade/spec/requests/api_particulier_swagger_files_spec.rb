RSpec.describe 'API Particulier: swagger files' do
  before do
    host! 'particulier.api.localtest.me'
  end

  describe 'main swagger' do
    subject(:get_swagger) do
      get '/api/open-api.yml'
    end

    it 'renders 200' do
      get_swagger

      expect(response).to have_http_status(:ok)
    end

    it 'renders valid yaml' do
      get_swagger

      expect {
        YAML.unsafe_load(response.body)
      }.not_to raise_error
    end
  end

  describe 'france connect swagger' do
    subject(:get_swagger) do
      get '/api/france-connect/open-api.yml'
    end

    it 'renders 200' do
      get_swagger

      expect(response).to have_http_status(:ok)
    end

    it 'renders valid yaml' do
      get_swagger

      expect {
        YAML.unsafe_load(response.body)
      }.not_to raise_error
    end
  end
end
