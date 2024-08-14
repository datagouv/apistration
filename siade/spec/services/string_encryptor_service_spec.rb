RSpec.describe StringEncryptorService do
  let(:message) { 'message' }
  let(:encrypted_message) { described_class.instance.encrypt(message) }

  describe '#encrypt' do
    subject { described_class.instance.encrypt(message) }

    it { is_expected.to be_a(String) }
    it { is_expected.not_to eq(message) }
  end

  describe '#decrypt' do
    subject { described_class.instance.decrypt(encrypted_message) }

    it { is_expected.to eq(message) }
  end

  describe 'URL safe methods' do
    let(:encrypted_message_url_safe) { described_class.instance.encrypt_url_safe(message) }

    describe '#encrypt_url_safe' do
      subject { described_class.instance.encrypt_url_safe(message) }

      it { is_expected.not_to match(%r{[+/]}) }
    end

    describe '#decrypt_url_safe' do
      subject { described_class.instance.decrypt_url_safe(encrypted_message_url_safe) }

      it { is_expected.to eq(message) }
    end
  end
end
