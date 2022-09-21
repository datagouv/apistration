RSpec.describe 'Ping routes', type: :request do
  subject(:ping) do
    get route
  end

  describe 'API entreprise' do
    before do
      host! 'entreprise.api.localtest.me'
    end

    context 'on v2' do
      let(:route) { '/v2/ping' }

      it 'works' do
        ping

        expect(response.status).to eq(200)
      end
    end

    context 'on v3' do
      let(:route) { '/v3/ping' }

      it 'works' do
        ping

        expect(response.status).to eq(200)
      end
    end
  end

  describe 'API particulier' do
    let(:route) { '/api/ping' }

    before do
      host! 'particulier.api.localtest.me'
    end

    it 'works' do
      ping

      expect(response.status).to eq(200)
    end
  end
end
