RSpec.describe SIADE::SelfHostedDocument::PDFDecrypt do
  subject { described_class.new(file_content).call }

  context 'with encrypted file' do
    let(:file_content) { open_payload_file('pdf/encrypted.pdf').read }

    it 'decrypts the PDF' do
      expect(subject).not_to include('Encrypt')
      expect(subject).not_to be_empty
    end
  end

  context 'when it is an invalid file' do
    context 'when pdf is damaged but only triggers warning' do
      let(:file_content) { open_payload_file('pdf/damaged-with-warnings.pdf').read }

      it 'renders a valid pdf file without encryption' do
        expect(subject).not_to include('Encrypt')
        expect(Marcel::MimeType.for(subject)).to eq('application/pdf')
      end
    end

    context 'when it is an invalid pdf' do
      let(:file_content) { open_payload_file('pdf/dummy.doc').read }

      it 'renders initial file' do
        expect(subject).to eq(file_content)
      end
    end
  end
end
