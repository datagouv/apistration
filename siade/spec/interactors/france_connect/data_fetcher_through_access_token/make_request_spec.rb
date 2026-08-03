RSpec.describe FranceConnect::DataFetcherThroughAccessToken::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(params:) }

  let(:token) { 'token' }
  let(:url) { Siade.credentials[:france_connect_v2_check_token_url] }
  let(:params) do
    {
      token:,
      api_name: 'quotient_familial'
    }
  end

  let!(:stubbed_request) do
    stub_request(:post, url).with(
      body: hash_including(
        token:
      )
    ).to_return(
      status: 200,
      body: france_connect_checktoken_payload.to_json
    )
  end

  it_behaves_like 'a make request with working mocking_params'

  context 'when in production' do
    before do
      allow(Rails).to receive(:env).and_return('production'.inquiry)
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }

    it 'calls production url with valid params' do
      make_call

      expect(stubbed_request).to have_been_requested
    end
  end

  context 'when in staging' do
    before do
      allow(Rails).to receive(:env).and_return('staging'.inquiry)
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(MockService).to receive(:mock_from_backend).and_return(mocked_data)
      # rubocop:enable RSpec/AnyInstance
    end

    context 'when a stubbed token is provided' do
      let(:mocked_data) do
        {
          status: 200,
          payload: {
            what: 'ever'
          }
        }
      end

      it { is_expected.to be_a_success }

      it 'does not call france connect' do
        make_call

        expect(stubbed_request).not_to have_been_requested
      end
    end

    context 'when the provided token is not stubbed' do
      let(:mocked_data) { nil }

      it { is_expected.to be_a_success }

      it 'does call france connect' do
        make_call

        expect(stubbed_request).to have_been_requested
      end
    end
  end

  context 'when FranceConnect client credentials are missing for this api_name' do
    before do
      allow(Rails).to receive(:env).and_return('production'.inquiry)
      allow(Siade.credentials).to receive(:[]).and_call_original
      allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_quotient_familial_client_id)
        .and_return('france_connect_v2_quotient_familial_client_id')
      allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_quotient_familial_client_secret)
        .and_return('france_connect_v2_quotient_familial_client_secret')
      allow(MonitoringService.instance).to receive(:track)
    end

    it 'tracks a distinct, alertable error to Sentry' do
      make_call

      expect(MonitoringService.instance).to have_received(:track).with(
        'error',
        a_string_including('quotient_familial'),
        fingerprint: %w[france-connect-missing-credentials quotient_familial]
      )
    end
  end

  context 'when FranceConnect client credentials are configured for this api_name' do
    before do
      allow(Rails).to receive(:env).and_return('production'.inquiry)
      allow(Siade.credentials).to receive(:[]).and_call_original
      allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_quotient_familial_client_id)
        .and_return('a_real_looking_client_id')
      allow(Siade.credentials).to receive(:[]).with(:france_connect_v2_quotient_familial_client_secret)
        .and_return('a_real_looking_client_secret')
      allow(MonitoringService.instance).to receive(:track)
    end

    it 'does not track anything' do
      make_call

      expect(MonitoringService.instance).not_to have_received(:track)
    end
  end
end
