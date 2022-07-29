RSpec.describe APIEntreprise::V2::UptimeController, type: :controller do
  let(:token) { uptime_jwt }

  it_behaves_like 'unauthorized'
  it_behaves_like 'forbidden'

  before do
    request.host = 'entreprise.api.localhost.me'
  end

  describe '#show' do
    before do
      request.headers[:Authorization] = "Bearer #{token}"
      get :show, params: { route: route }
    end

    describe 'existing route' do
      context 'when provider is UP', vcr: { cassette_name: 'uptime/entreprises' } do
        let(:route) { "/v2/entreprises/#{siren}" }

        let(:siren) { sirens_insee_v3[:active_GE] }

        it { expect(response).to have_http_status :ok }
      end

      describe 'more complexe route', vcr: { cassette_name: 'uptime/liasses_fiscales' } do
        let(:route) do
          "/v2/liasses_fiscales_dgfip/2017/declarations/#{valid_siren(:liasse_fiscale)}"
        end

        it { expect(response).to have_http_status :ok }
      end
    end

    describe 'not found route', vcr: { cassette_name: 'uptime/not_a_route' } do
      let(:route) { '/api/v2/not/a/route' }

      it { expect(response).to have_http_status :not_found }
    end
  end

  context 'when provider is DOWN' do
    before do
      stub_request(:get, /entreprise.api.gouv.fr/).to_return(status: 502)

      request.headers[:Authorization] = "Bearer #{token}"
      get :show, params: { route: route }
    end

    let(:route) { "v2/associations/#{siren}" }
    let(:siren) { valid_siren }

    it { expect(response).to have_http_status :bad_gateway }
  end

  context 'when provider timeout' do
    before do
      stub_request(:get, /entreprise.api.gouv.fr/).to_timeout

      request.headers[:Authorization] = "Bearer #{token}"
      get :show, params: { route: route }
    end

    let(:route) { "v2/associations/#{siren}" }
    let(:siren) { valid_siren }

    it { expect(response).to have_http_status :bad_gateway }
  end

  context 'when there is a socket error' do
    before do
      stub_request(:get, /entreprise.api.gouv.fr/).to_raise(SocketError)

      request.headers[:Authorization] = "Bearer #{token}"
      get :show, params: { route: route }
    end

    let(:route) { "v2/associations/#{siren}" }
    let(:siren) { valid_siren }

    it { expect(response).to have_http_status :bad_gateway }
  end
end
