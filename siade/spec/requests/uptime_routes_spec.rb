RSpec.describe 'Uptime routes', type: :request do
  subject(:uptime) do
    get uptime_path, params: { route: }, headers: { 'Authorization' => "Bearer #{uptime_jwt}" }
  end

  describe 'API entreprise' do
    before do
      host! 'entreprise.api.localtest.me'
    end

    context 'on v2', vcr: { cassette_name: 'uptime/api_entreprise/v2/entreprises' } do
      let(:uptime_path) { '/v2/uptime' }
      let(:route) { "/v2/entreprises/#{siren}" }
      let(:siren) { sirens_insee_v3[:active_GE] }

      it 'works' do
        uptime

        expect(response.status).to eq(200)
      end
    end

    context 'on v3', vcr: { cassette_name: 'uptime/api_entreprise/v3_and_more/entreprises' } do
      let(:uptime_path) { '/v3/uptime' }
      let(:route) { "/v3/insee/sirene/unites_legales/#{siren}" }
      let(:siren) { sirens_insee_v3[:active_GE] }

      it 'works' do
        uptime

        expect(response.status).to eq(200)
      end
    end
  end
end
