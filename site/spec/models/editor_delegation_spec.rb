RSpec.describe EditorDelegation do
  describe 'associations' do
    it { is_expected.to belong_to(:editor) }
    it { is_expected.to belong_to(:authorization_request) }
  end

  describe 'created_via' do
    it 'defaults to manual' do
      expect(create(:editor_delegation)).to be_manual
    end

    it 'rejects unknown values' do
      expect { build(:editor_delegation, created_via: 'other') }.to raise_error(ArgumentError)
    end
  end

  describe 'scopes' do
    let!(:active_delegation) { create(:editor_delegation) }
    let!(:revoked_delegation) { create(:editor_delegation, revoked_at: Time.zone.now) }

    describe '.active' do
      it 'returns only delegations without revoked_at' do
        expect(described_class.active).to contain_exactly(active_delegation)
      end
    end

    describe '.revoked' do
      it 'returns only delegations with revoked_at' do
        expect(described_class.revoked).to contain_exactly(revoked_delegation)
      end
    end
  end
end
