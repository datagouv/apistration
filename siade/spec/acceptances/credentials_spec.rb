RSpec.describe Siade, 'credentials' do
  describe '.credentials' do
    context 'when key does not exist and is a url' do
      subject(:credential) { described_class.credentials[:lolilol_url] }

      it 'returns a generated url' do
        expect(credential).to eq('https://lolilol_url.gouv.fr')
      end
    end

    context 'when key does not exist' do
      subject(:credential) { described_class.credentials[:lolilol] }

      it 'returns the key itself' do
        expect(credential).to eq('lolilol')
      end
    end
  end
end
