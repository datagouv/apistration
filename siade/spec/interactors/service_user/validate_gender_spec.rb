RSpec.describe ServiceUser::ValidateGender, type: :validate_params do
  subject { described_class.call(params: { gender: }) }

  let(:gender) { 'F' }

  context 'with valid gender' do
    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when gender is empty' do
    let(:gender) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when gender is not valid' do
    let(:gender) { 'nope' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
