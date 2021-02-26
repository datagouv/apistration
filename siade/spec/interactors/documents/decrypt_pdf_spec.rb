require 'rails_helper'

describe Documents::DecryptPDF do
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
end
