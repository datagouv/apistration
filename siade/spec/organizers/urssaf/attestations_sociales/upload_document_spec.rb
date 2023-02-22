RSpec.describe URSSAF::AttestationsSociales::UploadDocument, :self_hosted_doc do
  describe '.call' do
    subject { described_class.call(response:) }

    let(:response) { instance_double(Net::HTTPOK, code: 200, body:) }

    context 'when body is an encoded pdf' do
      let(:encoded_file_content) { encode64_payload_file('pdf/dummy.pdf') }
      let(:decoded_file_content) { Base64.strict_decode64(encoded_file_content) }
      let(:body) { encoded_file_content }

      it { is_expected.to be_success }

      its(:file_type) { is_expected.to eq('pdf') }
      its(:filename) { is_expected.to eq('attestation-vigilance-urssaf') }
      its(:content) { is_expected.to eq(decoded_file_content) }
      its(:url) { is_expected.to be_a_valid_self_hosted_pdf_url('attestation-vigilance-urssaf') }
    end

    context 'when body is a FUNC502 error' do
      let(:body) do
        [
          { code: 'FUNC502', message: 'Message 502', description: 'description' }
        ].to_json
      end

      it { is_expected.to be_a_success }

      its(:url) { is_expected.to be_nil }
    end
  end
end
