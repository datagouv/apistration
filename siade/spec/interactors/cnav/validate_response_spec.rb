RSpec.describe CNAV::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'CNAV') }

  context 'with 200 response' do
    let(:response) do
      instance_double(Net::HTTPOK, code: 200, body:)
    end

    context 'with valid body' do
      let(:body) { read_payload_file('cnav/complementaire_sante_solidaire/make_request_valid.json') }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'with invalid body' do
      let(:body) { 'lol' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end

  context 'with not found response' do
    context 'with sub provider error' do
      context 'with SNGI error, which translate an identity not found' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:)
        end

        let(:body) { read_payload_file('cnav/404-identity-not-found.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }

        it 'returns a SNGI error' do
          expect(subject.errors.first.detail).to include('Les paramètres fournis ne permettent pas')
        end
      end

      context 'with RNCPS 404 error, which translate a regime not found' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:)
        end

        let(:body) { read_payload_file('cnav/404-regime-not-found.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

        it 'returns a RNCPS error' do
          expect(subject.errors.first.detail).to include('éligibles')
        end
      end
    end

    context 'with regime error' do
      context 'with CNAF regime' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:, header: { 'X-APISECU-FD' => '00810011' })
        end

        let(:body) { read_payload_file('cnav/complementaire_sante_solidaire/404.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

        it 'returns a CNAF error, which translates to an identity found but not within regimes' do
          expect(subject.errors.first.detail).to include('CNAF')
        end
      end

      context 'with MSA regime' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:, header: { 'X-APISECU-FD' => '00171001' })
        end

        let(:body) { read_payload_file('cnav/complementaire_sante_solidaire/404.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

        it 'returns an MSA error, which translates to an identity found but not within regimes' do
          expect(subject.errors.first.detail).to include('MSA')
        end
      end

      context 'with RNCPS regime' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:, header: { 'X-APISECU-FD' => '99430000' })
        end

        let(:body) { read_payload_file('cnav/complementaire_sante_solidaire/404.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

        it 'returns a RNCPS error' do
          expect(subject.errors.first.detail).to include('RNCPS')
        end
      end
    end

    context 'with unknown provider' do
      let(:response) do
        instance_double(Net::HTTPNotFound, code: 404, body:, header: {})
      end

      let(:body) { read_payload_file('cnav/complementaire_sante_solidaire/404.json') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

      it 'returns a RNCPS error' do
        expect(subject.errors.first.detail).to include('Une erreur inattendue est survenue lors de la collecte des données')
      end
    end
  end

  context 'with 500 http code response' do
    let(:response) do
      instance_double(Net::HTTPInternalServerError, code: 500, body: '{"error":"Erreur technique non spécifiée","errorCode":50001}', header: { 'X-APISECU-FD' => '99430000' })
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }

    it 'tracks warning with response context and encrypted params' do
      expect(MonitoringService.instance).to receive(:track_with_added_context).with(
        'warning',
        '[CNAV] Internal server error (50001)',
        hash_including(:http_response_code, :http_response_body, :encrypted_params)
      )

      subject
    end
  end

  context 'with random http code response' do
    let(:response) do
      instance_double(Net::HTTPOK, code: 401)
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with 429 http code response' do
    let(:response) do
      instance_double(Net::HTTPTooManyRequests, code: 429)
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderRateLimitingError)) }
  end

  context 'with 400 http code response' do
    let(:response) do
      instance_double(Net::HTTPBadRequest, code: 400, body: '{"errorCode":40001,"error":"Civilité invalide"}')
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }

    it 'includes provider error code and message in meta' do
      expect(subject.errors.first.meta).to eq(
        provider_error_code: 40_001,
        provider_error_message: 'Civilité invalide'
      )
    end
  end
end
