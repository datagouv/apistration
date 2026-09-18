RSpec.describe InvalidTokenError, type: :error do
  it_behaves_like 'a valid error'

  describe '#detail' do
    it 'states the token is invalid by default' do
      expect(described_class.new.detail).to eq("Votre token n'est pas valide")
    end

    it 'states the token is invalid when the request carries one' do
      expect(described_class.new(:invalid).detail).to eq("Votre token n'est pas valide")
    end

    it 'states the token is missing when the request carries none' do
      expect(described_class.new(:missing).detail).to eq("Votre token n'est pas renseigné")
    end
  end

  describe '#code' do
    it 'stays 00101 whatever the reason, as the SDKs branch on it' do
      expect([described_class.new(:missing).code, described_class.new(:invalid).code]).to all(eq('00101'))
    end
  end
end
