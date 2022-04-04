RSpec.describe DGFIP::ValidateUserId, type: :validate_param do
  subject { described_class.call(params:) }

  let(:params) { { user_id: } }

  context 'with a user_id which is a uuid' do
    let(:user_id) { SecureRandom.uuid }

    it { is_expected.to be_a_success }
  end

  context 'with a user_id which is not a uuid' do
    let(:user_id) { "#{SecureRandom.uuid}whatever" }

    it { is_expected.to be_a_failure }
    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
