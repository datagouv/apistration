RSpec.describe ServiceUser::ValidateUserId, type: :validate_params do
  subject { described_class.call(params: { user_id: }) }

  let(:user_id) { '550e8400-e29b-41d4-a716-446655440000' }

  context 'with valid user_id' do
    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with invalid user_id' do
    let(:user_id) { 'invalid' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when user_id is empty' do
    let(:user_id) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
