RSpec.describe Documents::DecryptPDF do
  subject { described_class.call(params) }

  let(:params) do
    {
      content: file_content
    }
  end

  context 'with encrypted file' do
    let(:file_content) { open_payload_file('pdf/encrypted.pdf').read }

    it { is_expected.to be_a_success }

    it 'decrypts the PDF' do
      expect(subject.content).not_to include('Encrypt')
      expect(subject.content).not_to be_empty
    end
  end

  context 'when it is an invalid file' do
    context 'when pdf is damaged but only triggers warning' do
      let(:file_content) { open_payload_file('pdf/damaged-with-warnings.pdf').read }

      it { is_expected.to be_a_success }

      it 'renders a valid pdf file without encryption' do
        expect(subject.content).not_to include('Encrypt')
        expect(Marcel::MimeType.for(subject.content)).to eq('application/pdf')
      end
    end

    context 'when it is an invalid pdf' do
      let(:file_content) { open_payload_file('pdf/dummy.doc').read }

      it { is_expected.to be_a_success }

      it 'renders initial file' do
        expect(subject.content).to eq(file_content)
      end
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

    it { is_expected.to be_a_success }

    it 'does not raise error' do
      expect {
        subject
      }.not_to raise_error
    end

    it 'renders initial file' do
      expect(subject.content).to eq(file_content)
    end
  end
end
