RSpec.describe SIADE::SelfHostedDocument::File::ZIP, :self_hosted_doc do
  subject { described_class.new('file_label') }

  let(:zip_io) { open_payload_file('zip/dummy.zip').read }

  before { subject.store_from_binary(zip_io) }

  it { is_expected.to be_a(SIADE::SelfHostedDocument::File::Generic) }

  context 'when the format of the content is a valid ZIP' do
    it { is_expected.to be_success }
    its(:url) { is_expected.to be_a_valid_self_hosted_zip_url('file_label') }
  end

  context 'when the content is not a valid ZIP' do
    let(:zip_io) { 'not a ZIP' }

    it { is_expected.not_to be_success }
    its(:errors) { is_expected.to include([:invalid_extension, 'Le fichier n\'est pas au format `zip` attendu.']) }
  end
end
