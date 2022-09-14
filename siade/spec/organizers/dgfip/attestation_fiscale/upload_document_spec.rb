RSpec.describe DGFIP::AttestationFiscale::UploadDocument, :self_hosted_doc do
  describe '.call' do
    subject { described_class.call(response:) }

    let(:response) { instance_double(Net::HTTPOK, code:, body:) }
    let(:code) { 200 }
    let(:body) { Rails.root.join('spec/support/dgfip_attestations_fiscales/basic.pdf').read }

    it { is_expected.to be_success }

    its(:file_type) { is_expected.to eq('pdf') }

    its(:filename) { is_expected.to eq('attestation_fiscale_dgfip') }

    its(:content) { is_expected.to eq(body) }

    its(:url) { is_expected.to be_a_valid_self_hosted_pdf_url('attestation_fiscale_dgfip') }
  end
end
