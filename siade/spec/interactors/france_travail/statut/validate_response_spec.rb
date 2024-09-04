RSpec.describe FranceTravail::Statut::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject(:call) { described_class.call(response:, provider_name: 'CNAV') }

    context 'with 200 response' do
      let(:response) do
        instance_double(Net::HTTPOK, code: 200, body:)
      end

      context 'with valid body' do
        let(:body) { read_payload_file('pole_emploi/statut/valid.json') }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'with invalid body' do
        let(:body) { 'lol' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
      end
    end

    context 'with 404 response' do
      let(:response) do
        instance_double(Net::HTTPNotFound, code: 404, body:)
      end

      let(:body) { read_payload_file('pole_emploi/statut/not_found.json') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'with 206 response (partial content)' do
      let(:response) do
        instance_double(Net::HTTPNotFound, code: 206, body:)
      end

      let(:body) { read_payload_file('pole_emploi/partial_content.json') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'with random http code response' do
      let(:response) do
        instance_double(Net::HTTPOK, code: 400)
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end
end
