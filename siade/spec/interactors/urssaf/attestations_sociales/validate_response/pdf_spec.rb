RSpec.describe URSSAF::AttestationsSociales::ValidateResponse::PDF, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response:, provider_name: 'ACOSS') }

    let(:response) do
      instance_double(Net::HTTPOK, code:, body:)
    end
    let(:code) { 200 }

    context 'with a valid base64 body' do
      let(:body) { Base64.strict_encode64('whatever') }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
      its(:cacheable) { is_expected.to be(true) }
    end

    context 'when body is not a base64 string' do
      context 'when body is not a FUNC502 error' do
        let(:body) { '!!!invalid-base64!!!' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

        its(:cacheable) { is_expected.to be(false) }
      end

      context 'when body is a FUNC502 error' do
        let(:body) do
          [
            { code: 'FUNC502', message: 'Message 502', description: 'description' }
          ].to_json
        end

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
        its(:cacheable) { is_expected.to be(true) }
      end
    end
  end
end
