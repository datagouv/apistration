RSpec.describe SIADE::SelfHostedDocument::PDFDecrypt do
  subject { described_class.new(file_content).call }

  context 'with encrypted file' do
    let(:file_content) { open_payload_file('pdf/encrypted.pdf').read }

    it 'decrypts the pdf' do
      expect(subject).not_to include('Encrypt')
    end

    it 'renders a valid pdf' do
      expect(Marcel::MimeType.for(subject)).to eq('application/pdf')
    end
  end

  context 'when it is an invalid file' do
    context 'when pdf is damaged but only triggers warning' do
      let(:file_content) { open_payload_file('pdf/damaged-with-warnings.pdf').read }

      it 'renders a valid pdf' do
        expect(Marcel::MimeType.for(subject)).to eq('application/pdf')
      end

      it 'decrypts the pdf' do
        expect(subject).not_to include('Encrypt')
      end
    end

    context 'when it is an invalid pdf' do
      let(:file_content) { open_payload_file('pdf/dummy.doc').read }

      it 'renders initial file' do
        expect(subject).to eq(file_content)
      end
    end

    context 'when hexa pdf raised an unknown error' do
      let(:file_content) { open_payload_file('pdf/dummy.pdf').read }

      before do
        allow_any_instance_of(HexaPDF::Document).to receive(:write).and_raise(
          HexaPDF::Error.new('PANIK')
        )
      end

      it 'raises error' do
        expect {
          subject
        }.to raise_error(HexaPDF::Error)
      end
    end

    context 'when hexa pdf raised an error with "Required field Parent is not set" message' do
      let(:file_content) { open_payload_file('pdf/dummy.pdf').read }

      before do
        allow_any_instance_of(HexaPDF::Document).to receive(:write).and_raise(
          HexaPDF::Error.new('Validation error for (48,0): Required field Parent is not set')
        )
      end

      it 'does not raise error' do
        expect {
          subject
        }.not_to raise_error
      end

      it 'renders initial file' do
        expect(subject).to eq(file_content)
      end
    end
  end
end
