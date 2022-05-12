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
end
