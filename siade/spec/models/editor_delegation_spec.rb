RSpec.describe EditorDelegation do
  describe '.active' do
    let(:editor) { Editor.create!(name: 'Test Editor') }
    let(:authorization_request) { AuthorizationRequest.create!(siret: '12345678901234', scopes: []) }
    let(:revoked_ar) { AuthorizationRequest.create!(siret: '12345678901235', scopes: []) }

    let!(:active_delegation) do
      described_class.create!(editor:, authorization_request:)
    end

    before do
      described_class.create!(editor:, authorization_request: revoked_ar, revoked_at: 1.day.ago)
    end

    it 'returns only delegations without revoked_at' do
      expect(described_class.active.where(editor:)).to contain_exactly(active_delegation)
    end
  end
end
