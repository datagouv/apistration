require 'rails_helper'

RSpec.describe Documents::DecryptPDF do
  subject { described_class.call(decrypt_params) }

  let(:encrypted_content) { open_payload_file('pdf/encrypted.pdf').read }
  let(:decrypt_params) do
    { content: encrypted_content }
  end

  context 'when we call the interactor' do
    it { is_expected.to be_success }

    it 'decrypts the PDF' do
      expect(subject.content).not_to include('Encrypt')
      expect(subject.content).not_to be_empty
    end
  end

  context 'on the raw encrypted pdf' do
    it 'is encrypted' do
      expect(encrypted_content).to include('Encrypt')
    end
  end

  context 'when qpdf system command returns an error' do
    before do
      allow_any_instance_of(described_class).to receive(:command).and_return(
        'qpdf lol oki',
      )
    end

    it 'tracks error' do
      expect(MonitoringService.instance).to receive(:track).with(
        'error',
        "PDF Decrypt fail to execute 'qpdf lol oki'",
        {
          exit_status: 2,
          stderr: 'open lol: No such file or directory',
        },
      )

      subject
    end
  end
end
