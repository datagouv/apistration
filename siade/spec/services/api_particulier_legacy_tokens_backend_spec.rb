RSpec.describe APIParticulierLegacyTokensBackend, type: :service do
  describe '.exists?' do
    subject { described_class.exists?(key) }

    context 'when key exists' do
      let(:key) { '1_scope' }

      it { is_expected.to be true }
    end

    context 'when key does not exist' do
      let(:key) { 'invalid' }

      it { is_expected.to be false }
    end
  end

  describe '.get' do
    subject(:token_data) { described_class.get(key) }

    context 'when key exists' do
      let(:key) { '1_scope' }

      it { is_expected.to be_present }

      it { expect(token_data['scopes']).to eq(['scope1']) }
      it { expect(token_data['legacy_token_id']).to be_present }
      it { expect(token_data['token_id']).to be_present }
    end

    context 'with a valid token which has a sha512 value in backend' do
      let(:key) { 'hashed_value' }

      it { is_expected.to be_present }

      it { expect(token_data['scopes']).to eq(['initial_value_of_this_token_is:hashed_value']) }
      it { expect(token_data['legacy_token_id']).to be_present }
      it { expect(token_data['token_id']).to be_present }
    end

    context 'when key does not exist' do
      let(:key) { 'invalid' }

      it { is_expected.to be_blank }
    end
  end
end
