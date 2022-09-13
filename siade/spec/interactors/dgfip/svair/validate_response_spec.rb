RSpec.describe DGFIP::SVAIR::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject(:call) { described_class.call(response:, provider_name: 'DGFIP') }

    let(:response) do
      instance_double(Net::HTTPOK, code:, body:)
    end

    context 'with an invalid code' do
      let(:code) { '500' }
      let(:body) { 'whatever' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

      its(:cacheable) { is_expected.to be(false) }
    end

    context 'with a 200 code' do
      let(:code) { '200' }

      context 'with a body which is a access denied' do
        let(:body) { File.read(Rails.root.join('spec/fixtures/payloads/dgfip-svair-access-denied.html')) }

        it { is_expected.to be_a_failure }

        its(:cacheable) { is_expected.to be(false) }

        its(:errors) { is_expected.to include(instance_of(DGFIPSVAIRAccessDeniedError)) }

        it 'captures error in monitoring' do
          expect(MonitoringService.instance).to receive(:track).with(
            'error',
            anything
          )

          call
        end
      end

      context 'with a body which is a not found result' do
        let(:body) { File.read(Rails.root.join('spec/fixtures/payloads/dgfip-svair-not-found.html')) }

        it { is_expected.to be_a_failure }

        its(:cacheable) { is_expected.to be(true) }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end

      context 'with a body which is a valid response' do
        let(:body) { File.read(Rails.root.join('spec/fixtures/payloads/dgfip-svair-valid-response-one-declarant.html')) }

        it { is_expected.to be_a_success }

        its(:cacheable) { is_expected.to be(true) }

        its(:errors) { is_expected.to be_empty }
      end
    end
  end
end
