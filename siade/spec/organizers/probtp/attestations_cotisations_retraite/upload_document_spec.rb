RSpec.describe PROBTP::AttestationsCotisationsRetraite::UploadDocument, :self_hosted_doc do
  describe '.call' do
    subject { described_class.call(response:) }

    let(:response) { instance_double(Net::HTTPOK, code:, body:) }
    let(:code) { 200 }
    let(:encoded_file_content) { encode64_payload_file('pdf/dummy.pdf') }
    let(:decoded_file_content) { Base64.strict_decode64(encoded_file_content) }
    let(:body) { "{\"what\": \"ever\", \"data\": \"#{encoded_file_content}\"}" }

    it { is_expected.to be_success }

    its(:file_type) { is_expected.to eq('pdf') }

    its(:filename) { is_expected.to eq('attestation_cotisation_retraite_probtp') }

    its(:content) { is_expected.to eq(decoded_file_content) }

    its(:url) { is_expected.to be_a_valid_self_hosted_pdf_url('attestation_cotisation_retraite_probtp') }
  end
end
