RSpec.describe DataEncryptor do
  describe '#encrypt' do
    subject { described_class.new(data).encrypt }

    let(:crypto) { GPGME::Crypto.new }
    let(:data) { 'data' }

    it 'creates a valid gpg encrypt data' do
      crypto.verify(subject) do |signature|
        expect(signature).to be_valid
        expect(signature.from).to include('ci@example.com')
      end
    end
  end

  describe '#decrypt' do
    subject { described_class.new(data).decrypt }

    let(:data) { described_class.new('data').encrypt }

    it 'can descrypt encrypted data' do
      expect(subject.to_s).to eq('data')
    end
  end
end
