RSpec.describe FranceTravail::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      user_id:,
      identifiant:
    }
  end

  let(:user_id) { SecureRandom.uuid }
  let(:identifiant) { 'whatever' }

  context 'with valid params' do
    it { is_expected.to be_a_success }
  end

  context 'without identifiant' do
    let(:identifiant) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with a blank identifiant' do
    let(:identifiant) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with a blank user_id' do
    let(:user_id) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with a non uuid user_id' do
    let(:user_id) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
