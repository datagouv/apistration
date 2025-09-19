RSpec.describe AvailableMCPTools do
  describe '#perform' do
    subject { described_class.instance.perform }

    it { is_expected.to include(Infogreffe::ExtraitsRCSTool) }
    it { is_expected.not_to include(ApplicationTool) }
  end
end
