RSpec.describe ANTS::ExtraitImmatriculationVehicule::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:, token:) }

    let(:token) { 'test_token' }
    let(:params) do
      {
        immatriculation: 'nm-257-nz',
        nom_naissance: 'Dupont',
        prenoms: ['Martin']
      }
    end

    let!(:stubbed_request) do
      stub_request(:post, Siade.credentials[:ants_siv2_url])
        .with(
          headers: {
            'Content-Type' => 'application/json',
            'X-Http-Method-Override' => 'GET',
            'Authorization' => 'Bearer test_token'
          },
          body: {
            modeAppel: 'L',
            informations: {
              numImmat: 'NM-257-NZ'
            }
          }
        )
        .to_return(
          status: 200,
          body: { code: 0, libelle: 'Succès', listeDossiers: [] }.to_json
        )
    end

    it { is_expected.to be_a_success }

    it 'calls url with correct params' do
      subject

      expect(stubbed_request).to have_been_requested
    end

    context 'when the provider rejected the cached token' do
      let(:token) { 'stale_token' }

      let!(:stubbed_rejected_request) do
        stub_request(:post, Siade.credentials[:ants_siv2_url])
          .with(headers: { 'Authorization' => 'Bearer stale_token' })
          .to_return(status: 401, body: '')
      end
      let!(:stubbed_authenticate) { stub_ants_authenticate }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }

      it 'replays the call once with a freshly retrieved token' do
        subject

        expect(stubbed_rejected_request).to have_been_made.once
        expect(stubbed_authenticate).to have_been_made.once
        expect(stubbed_request).to have_been_made.once
      end
    end

    context 'when the provider keeps rejecting a freshly retrieved token' do
      let(:token) { 'stale_token' }

      let!(:stubbed_authenticate) { stub_ants_authenticate }
      let!(:stubbed_rejected_request) do
        stub_request(:post, Siade.credentials[:ants_siv2_url])
          .with(headers: { 'Authorization' => 'Bearer stale_token' })
          .to_return(status: 401, body: '')
      end
      let!(:stubbed_rejected_retry) do
        stub_request(:post, Siade.credentials[:ants_siv2_url])
          .with(headers: { 'Authorization' => 'Bearer test_token' })
          .to_return(status: 401, body: '')
      end

      it 'does not loop over authentication' do
        subject

        expect(stubbed_authenticate).to have_been_made.once
        expect(stubbed_rejected_request).to have_been_made.once
        expect(stubbed_rejected_retry).to have_been_made.once
      end

      its(:response) { is_expected.to be_a(Net::HTTPUnauthorized) }
    end
  end
end
