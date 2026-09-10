RSpec.describe CNAV::QuotientFamilialV2::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'CNAF & MSA') }

  context 'with 200 response' do
    let(:response) do
      instance_double(Net::HTTPOK, code: 200, body: read_payload_file('cnav/quotient_familial_v2/make_request_valid.json'))
    end

    it { is_expected.to be_a_success }
  end

  context 'with 400 http code response' do
    let(:response) do
      instance_double(Net::HTTPBadRequest, code: 400, body:, header: { 'X-APISECU-FD' => '00810011' })
    end

    before do
      allow(MonitoringService.instance).to receive(:track_with_added_context)
    end

    context 'with the period too old for the CNAV (40029)' do
      let(:body) { '{"errorCode":"40029","error":"La date demandee est trop ancienne"}' }

      it { is_expected.to be_a_failure }

      it 'rejects the period, naming the provider and its error' do
        error = subject.errors.first

        expect(error).to be_a(ProviderUnprocessableEntityError)
        expect(error.code).to eq('35565')
        expect(error.detail).to eq('La période demandée est antérieure de plus de 24 mois.')
        expect(error.meta).to eq(
          provider: 'CNAF & MSA',
          provider_error_code: '40029',
          provider_error_message: 'La date demandee est trop ancienne'
        )
      end

      it 'still tracks the bad request with its regime' do
        subject

        expect(MonitoringService.instance).to have_received(:track_with_added_context).with(
          'error',
          '[CNAF & MSA] Bad request (40029)',
          hash_including(regime: 'CNAF'),
          fingerprint: %w[cnav-bad-request 40029]
        )
      end
    end

    context 'with a failure of the family provider (40000)' do
      let(:body) { '{"errorCode":40000,"error":"RESSOURCE INCONNUE, CALCUL QF IMPOSSIBLE"}' }

      it { is_expected.to be_a_failure }

      it 'preserves the provider error when remapping it to an internal error' do
        error = subject.errors.first

        expect(error).to be_an_instance_of(ProviderInternalServerError)
        expect(error.code).to eq('35000')
        expect(error.meta).to eq(
          provider: 'CNAF & MSA',
          provider_error_code: 40_000,
          provider_error_message: 'RESSOURCE INCONNUE, CALCUL QF IMPOSSIBLE'
        )
      end

      it 'includes the provider error code in access log fields' do
        RenderedError.capture(subject.errors)

        expect(RenderedError.log_fields).to include(provider_error_code: '40000')
      end
    end

    context 'with a wrong data provider routing (40024)' do
      let(:body) { '{"errorCode":"40024","error":"Fournisseur de données errone"}' }

      it { is_expected.to be_a_failure }

      it 'preserves the provider error when remapping it to an internal error' do
        error = subject.errors.first

        expect(error).to be_an_instance_of(ProviderInternalServerError)
        expect(error.code).to eq('35000')
        expect(error.meta).to eq(
          provider: 'CNAF & MSA',
          provider_error_code: '40024',
          provider_error_message: 'Fournisseur de données errone'
        )
      end

      it 'includes the provider error code in access log fields' do
        RenderedError.capture(subject.errors)

        expect(RenderedError.log_fields).to include(provider_error_code: '40024')
      end
    end

    context 'with a civility rejection (40014)' do
      let(:body) { '{"errorCode":40014,"error":"Code Sexe absent"}' }

      it { is_expected.to be_a_failure }

      it 'keeps the generic civility rejection' do
        error = subject.errors.first

        expect(error).to be_a(ProviderUnprocessableEntityError)
        expect(error.code).to eq('35561')
        expect(error.meta).to include(provider_error_code: 40_014)
      end
    end
  end
end
