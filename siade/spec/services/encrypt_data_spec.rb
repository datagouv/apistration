RSpec.describe EncryptData do
  describe '#perform' do
    subject { described_class.new(data).perform }

    let(:crypto) { GPGME::Crypto.new }
    let(:data) { 'data' }

    it 'creates a valid gpg encrypt data' do
      crypto.verify(subject) do |signature|
        expect(signature).to be_valid
        expect(signature.from).to include('ci@example.com')
      end
    end
  end
end
