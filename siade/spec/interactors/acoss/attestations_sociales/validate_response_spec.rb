RSpec.describe ACOSS::AttestationsSociales::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response:, provider_name: 'ACOSS') }

    let(:response) do
      instance_double('Net::HTTPOK', code:, body:)
    end
    let(:code) { 200 }

    context 'with a valid body, which is an encode 64 string' do
      let(:body) { Base64.strict_encode64('whatever') }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'with an empty body' do
      let(:body) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
    end

    context 'when body has an error payload' do
      let(:body) { json_errors.to_json }

      context 'when it has at least one internal error code' do
        let(:json_errors) do
          [
            { code: 'FUNC502', message: 'Message 502', description: 'description 2' },
            { code: 'FUNC517', message: 'Message 517', description: 'description 17' }
          ]
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
      end

      context 'when it is only not found errors codes' do
        let(:json_errors) do
          [
            { code: 'FUNC501', message: 'Message 501', description: 'description 1' },
            { code: 'FUNC517', message: 'Message 517', description: 'description 17' }
          ]
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

        it 'adds meta with json errors' do
          subject

          error = subject.errors.first

          expect(error.meta[:provider_errors]).to eq(
            json_errors
          )
        end
      end

      context 'when company situation requires manual operation by the provider' do
        let(:json_errors) do
          [
            { code: 'FUNC503', message: 'manual operation needed', description: 'do something' }
          ]
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ACOSSError)) }
      end

      context 'when it is a hash instead of an array' do
        let(:json_errors) do
          {
            oki: 'wtf??'
          }
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

        it 'adds monitoring private context with json body to error' do
          subject

          error = subject.errors.first

          expect(error.monitoring_private_context).to eq(
            body: json_errors.to_json
          )
        end
      end
    end
  end
end
