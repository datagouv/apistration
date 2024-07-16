RSpec.describe CIBTP::AttestationsCotisationsChomageIntemperies::UploadDocument, :self_hosted_doc do
  subject { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, code:, body:) }
  let(:code) { 200 }
  let(:body) { read_payload_file('pdf/dummy.pdf') }

  it { is_expected.to be_success }

  its(:file_type) { is_expected.to eq('pdf') }
  its(:filename) { is_expected.to eq('attestations_cotisations_chomage_intemperies_cibtp') }
  its(:content) { is_expected.to eq(body) }
  its(:url) { is_expected.to be_a_valid_self_hosted_pdf_url('attestations_cotisations_chomage_intemperies_cibtp') }
end
