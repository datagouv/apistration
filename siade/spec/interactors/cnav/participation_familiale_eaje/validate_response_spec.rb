RSpec.describe CNAV::ParticipationFamilialeEAJE::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'CNAV') }

  context 'with 200 response' do
    let(:response) do
      instance_double(Net::HTTPOK, code: 200, body:)
    end

    context 'with valid body and kids under 7' do
      let(:body) { read_payload_file('cnav/participation_familiale_eaje/make_request_valid.json') }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'with valid body but no kids under 7' do
      let(:body) { read_payload_file('cnav/participation_familiale_eaje/make_request_no_kids_under_7.json') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

      it 'returns a specific error message from CNAV' do
        expect(subject.errors.first.provider_name).to eq('CNAV')
        expect(subject.errors.first.detail).to include('participation familiale EAJE')
      end

      it 'logs potential unauthorized API usage' do
        expect(MonitoringService.instance).to receive(:track).with(
          'info',
          'Potential unauthorized API use: CNAV EAJE: allocataire found but no kids under 7'
        )

        subject
      end
    end
  end

  context 'with 500 response' do
    let(:response) do
      instance_double(Net::HTTPInternalServerError, code: 500)
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

    it 'returns the parent 500 error, not the no_kids_under_7 error' do
      expect(subject.errors.first).to be_a(ProviderUnknownError)
      expect(subject.errors.first).not_to be_a(NotFoundError)
    end
  end
end
