RSpec.describe Civility::ValidatePrenoms, type: :validate_params do
  subject { described_class.call(params: { prenoms: }) }

  let(:prenoms) { %w[Loic Samuel Thomas] }

  context 'with valid prenoms' do
    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when a prenom is a comma-separated composite name' do
    let(:prenoms) { ['LILY-ROSE, CLARA'] }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when a prenom contains a digit' do
    let(:prenoms) { ['GUIOT2'] }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when a prenom contains round brackets' do
    let(:prenoms) { ['GUIOT (BIS)'] }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when a prenom contains square brackets' do
    let(:prenoms) { ['GUIOT [BIS]'] }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid user_id' do
    context 'when prenoms is empty' do
      let(:prenoms) { [] }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when prenoms is nil' do
      let(:prenoms) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when prenoms array contains a non-string element' do
      let(:prenoms) { ['Jean', { 'foo' => 'bar' }] }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end
end
