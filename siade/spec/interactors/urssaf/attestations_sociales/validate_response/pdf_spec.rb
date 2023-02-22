RSpec.describe URSSAF::AttestationsSociales::ValidateResponse::PDF, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response:, provider_name: 'ACOSS') }

    let(:response) do
      instance_double(Net::HTTPOK, code:, body:)
    end
    let(:code) { 200 }

    context 'with a base64 body' do
      let(:extractor) { instance_double(URSSAFAttestationVigilanceExtractor, perform: extractor_data) }
      let(:body) { Base64.strict_encode64('whatever') }
      let(:extractor_data) { {} }

      before do
        allow(URSSAFAttestationVigilanceExtractor).to receive(:new).and_return(extractor)
      end

      context 'when extractor returns valid data' do
        let(:extractor_data) do
          {
            code_securite: 'QWERTYUYTREWERT',
            date_debut_validite: Date.new(2022, 12, 31)
          }
        end

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
        its(:cacheable) { is_expected.to be(true) }

        it 'calls the extractor with body decrypted' do
          expect(URSSAFAttestationVigilanceExtractor).to receive(:new).with('whatever')

          subject
        end
      end

      context 'when extractor raises an exception' do
        before do
          allow(extractor).to receive(:perform).and_raise(URSSAFAttestationVigilanceExtractor::InvalidAttestationVigilance)
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

        its(:cacheable) { is_expected.to be(false) }
      end
    end

    context 'when body is not a base64 string' do
      context 'when body is not a FUNC502 error' do
        let(:body) { 'Nonsense' }

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
