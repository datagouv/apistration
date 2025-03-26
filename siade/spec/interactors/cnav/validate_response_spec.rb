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
      context 'with SNGI error' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:)
        end

        let(:body) { read_payload_file('cnav/40409.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }

        it 'returns a SNGI error' do
          expect(subject.errors.first.detail).to include('Les paramètres fournis ne permettent pas')
        end
      end

      context 'with RNCPS error' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:)
        end

        let(:body) { read_payload_file('cnav/40406.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

        it 'returns a SNGI error' do
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

        it 'returns a CNAF error' do
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

        it 'returns an MSA error' do
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
      instance_double(Net::HTTPTooManyRequests, code: 400)
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
