RSpec.describe SwaggerInformation do
  describe '.get' do
    subject(:get_key) { described_class.get(key) }

    context 'with valid key' do
      let(:key) { 'insee.entreprise' }

      it { is_expected.to be_an_instance_of(Hash) }
    end

    context 'with invalid key' do
      let(:key) { 'what.ever' }

      it do
        expect {
          get_key
        }.to raise_error(KeyError)
      end
    end
  end
end
