RSpec.describe ServiceUser::ValidateBirthPlace, type: :validate_params do
  subject { described_class.call(params: { birth_place: }) }

  let(:birth_place) { 'Montpellier' }

  context 'with valid birth_place' do
    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when birth_place is empty' do
    let(:birth_place) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
