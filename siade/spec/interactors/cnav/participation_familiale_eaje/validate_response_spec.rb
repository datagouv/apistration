RSpec.describe CNAV::ParticipationFamilialeEAJE::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'Sécurité sociale') }

  it_behaves_like 'a CNAV response validator'

  context 'with 200 response' do
    let(:response) do
      instance_double(Net::HTTPOK, code: 200, body:, header: { 'X-APISECU-FD' => '00810011' })
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

      it 'records the missing person and the caisse that answered' do
        expect(subject.no_result).to eq(error: subject.errors.first, origin: 'CNAF')
      end
    end
  end

  describe 'the missing person record' do
    def not_found_response(payload, header = {})
      instance_double(Net::HTTPNotFound, code: 404, body: read_payload_file(payload), header:)
    end

    context 'when no eligible caisse knows the allocataire' do
      let(:response) { not_found_response('cnav/404-regime-not-found.json') }

      it 'names the RNCPS as origin' do
        expect(subject.no_result).to eq(error: subject.errors.first, origin: 'RNCPS')
      end
    end

    context 'when the MSA has no file for the allocataire' do
      let(:response) { not_found_response('cnav/complementaire_sante_solidaire/404.json', 'X-APISECU-FD' => '00171001') }

      it 'names the caisse as origin' do
        expect(subject.no_result).to eq(error: subject.errors.first, origin: 'MSA')
      end
    end

    context 'when the SNGI does not identify the allocataire' do
      let(:response) { not_found_response('cnav/404-identity-not-found.json') }

      it 'records nothing: the error is not a missing person' do
        expect(subject.no_result).to be_nil
      end
    end
  end

  context 'with 500 response' do
    let(:response) do
      instance_double(Net::HTTPInternalServerError, code: 500, body: '{"error":"Erreur technique","errorCode":50001}', header: { 'X-APISECU-FD' => '99430000' })
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }

    it 'returns the parent 500 error, not the no_kids_under_7 error' do
      expect(subject.errors.first).to be_a(ProviderInternalServerError)
      expect(subject.errors.first).not_to be_a(NotFoundError)
    end
  end
end
