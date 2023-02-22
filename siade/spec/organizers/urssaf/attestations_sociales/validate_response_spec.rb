RSpec.describe URSSAF::AttestationsSociales::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response:, provider_name: 'ACOSS') }

    context 'with valid response object (happy path)' do
      let(:response) do
        instance_double(Net::HTTPOK, code: '200', body:)
      end

      let(:body) { Base64.strict_encode64(valid_pdf) }
      let(:valid_pdf) { Rails.root.join('spec/support/urssaf_attestations_sociales/basic.pdf').read }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
      its(:cacheable) { is_expected.to be(true) }
    end
  end
end
