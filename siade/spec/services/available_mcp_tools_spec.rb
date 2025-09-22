RSpec.describe AvailableMCPTools do
  describe '#perform' do
    subject { described_class.instance.perform(protected_data:) }

    context 'when protected_data is true' do
      let(:protected_data) { true }

      it { is_expected.to include(Infogreffe::ExtraitsRCSTool) }
      it { is_expected.to include(URSSAF::AttestationsSocialesTool) }
      it { is_expected.not_to include(ApplicationTool) }
    end

    context 'when protected_data is false' do
      let(:protected_data) { false }

      it { is_expected.to include(Infogreffe::ExtraitsRCSTool) }
      it { is_expected.not_to include(URSSAF::AttestationsSocialesTool) }
    end
  end
end
