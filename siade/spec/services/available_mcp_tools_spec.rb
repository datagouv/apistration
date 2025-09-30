RSpec.describe AvailableMCPTools do
  describe '#perform' do
    subject { described_class.instance.perform(scopes:) }

    let(:scopes) { %w[mcp_scope1 mcp_scope2 other_scope] }

    it 'returns tools related to the given scopes' do
      expect(subject).to contain_exactly(
        URSSAF::AttestationsSocialesTool,
        INSEE::UniteLegaleTool
      )
    end
  end
end
