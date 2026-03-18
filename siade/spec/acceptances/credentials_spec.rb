RSpec.describe Siade, 'credentials' do
  describe '.credentials' do
    subject(:credential) { described_class.credentials[key] }

    context 'when key exists' do
      let(:key) { :jwt_hash_secret }

      it 'renders value' do
        expect(credential).to eq('this_is_a_valid_jwt_hash_for_spec')
      end
    end

    context 'when key does not exist' do
      let(:key) { :lolilol }

      it 'raises KeyError error' do
        expect {
          credential
        }.to raise_error(KeyError)
      end
    end
  end
end
