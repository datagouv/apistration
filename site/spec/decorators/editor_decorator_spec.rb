RSpec.describe EditorDecorator do
  describe '#role_label' do
    subject { described_class.new(editor).role_label }

    context 'when role is set' do
      let(:editor) { build(:editor, role: 'manages_token') }

      it { is_expected.to eq('Gère le jeton') }
    end

    context 'when role is both' do
      let(:editor) { build(:editor, role: 'both') }

      it { is_expected.to eq('Les deux') }
    end

    context 'when role is nil' do
      let(:editor) { build(:editor, role: nil) }

      it { is_expected.to eq('Rôle inconnu') }
    end
  end

  describe '#deployment_type_label' do
    subject { described_class.new(editor).deployment_type_label }

    context 'when deployment_type is set' do
      let(:editor) { build(:editor, deployment_type: 'on_premise') }

      it { is_expected.to eq('On-premise') }
    end

    context 'when deployment_type is nil' do
      let(:editor) { build(:editor, deployment_type: nil) }

      it { is_expected.to eq('Déploiement inconnu') }
    end
  end
end
