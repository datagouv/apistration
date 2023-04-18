RSpec.describe MESRI::StudentStatus::WithCivility::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      family_name:,
      first_name:,
      birth_date:,
      birth_place:,
      gender:,
      token_id:
    }
  end

  let(:family_name) { 'Dupont' }
  let(:first_name) { 'Jean' }
  let(:birth_date) { '2000-01-01' }
  let(:birth_place) { 'Paris' }
  let(:gender) { 'm' }

  let(:token_id) { SecureRandom.uuid }

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
  end

  context 'without birthday place' do
    let(:birth_place) { '' }

    it { is_expected.to be_a_success }
  end

  context 'without first name' do
    let(:first_name) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'without family name' do
    let(:family_name) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid gender' do
    let(:gender) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'without gender' do
    let(:gender) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid birthday date' do
    let(:birth_date) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
