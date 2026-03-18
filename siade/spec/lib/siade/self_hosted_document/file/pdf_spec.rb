RSpec.describe SIADE::SelfHostedDocument::File::PDF, :self_hosted_doc do
  subject { described_class.new('file_label') }

  let(:pdf_io) { open_payload_file('pdf/dummy.pdf').read }

  # Using #store_from_binary as it is the easier to setup
  # Other methods are tested into the generic interface
  before { subject.store_from_binary(pdf_io) }

  it { is_expected.to be_a(SIADE::SelfHostedDocument::File::Generic) }

  context 'when the format of the content is a valid PDF' do
    it { is_expected.to be_success }

    its(:url) { is_expected.to be_a_valid_self_hosted_pdf_url('file_label') }
  end

  context 'when the content is not a valid PDF' do
    let(:pdf_io) { 'not a PDF UMAD' }

    it { is_expected.to_not be_success }
    its(:errors) { is_expected.to include([:invalid_extension, 'Le fichier n\'est pas au format `pdf` attendu.']) }
  end

  context 'when :decrypt_pdf is set to true' do
    let(:encrypted_pdf) { 'much encrypt' }

    before do
      allow_any_instance_of(SIADE::SelfHostedDocument::PDFDecrypt)
        .to receive(:call).and_return('very decrypt')
      allow_any_instance_of(SIADE::SelfHostedDocument::FormatValidator)
        .to receive(:valid?).with('very decrypt').and_return(true)
    end

    it 'uploads the decrypted content' do
      expect(SIADE::SelfHostedDocument::Uploader)
        .to receive(:call).with('random-name.pdf', 'very decrypt')

      pdf = described_class.new('random-name', decrypt: true)
      pdf.store_from_binary(encrypted_pdf)
    end
  end
end
