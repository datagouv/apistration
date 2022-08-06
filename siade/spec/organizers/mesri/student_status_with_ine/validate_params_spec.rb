RSpec.describe MESRI::StudentStatusWithINE::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      ine:,
      user_id:
    }
  end

  let(:ine) { '1234567890G' }
  let(:user_id) { SecureRandom.uuid }

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
  end

  context 'with invalid ine' do
    let(:ine) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid user_id' do
    let(:user_id) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
