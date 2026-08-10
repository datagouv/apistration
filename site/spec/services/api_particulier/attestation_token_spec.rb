require 'rails_helper'

RSpec.describe APIParticulier::AttestationToken do
  describe '.read_verification' do
    subject(:read_verification) { described_class.read_verification(token) }

    let(:password) { SecureRandom.hex(32) }
    let(:salt) { SecureRandom.hex(16) }
    let(:payload) { { 'siret' => '13002526500013', 'sections' => [] } }

    let(:token) do
      key = ActiveSupport::KeyGenerator.new(password).generate_key(salt, 32)
      encryptor = ActiveSupport::MessageEncryptor.new(key, url_safe: true, serializer: ActiveSupport::MessageEncryptor::NullSerializer)

      encryptor.encrypt_and_sign(Zlib::Deflate.deflate(payload.to_json), purpose: :attestation_verification)
    end

    before do
      allow(AdminApientreprise.credentials).to receive(:[]).and_call_original
      allow(AdminApientreprise.credentials).to receive(:[]).with(:attestation_encryptor_password).and_return(password)
      allow(AdminApientreprise.credentials).to receive(:[]).with(:attestation_encryptor_salt).and_return(salt)
      described_class.instance_variable_set(:@encryptor, nil)
    end

    after { described_class.instance_variable_set(:@encryptor, nil) }

    it 'decrypts a token sealed with the pair configured in the app credentials' do
      expect(read_verification).to eq(payload)
    end
  end
end
