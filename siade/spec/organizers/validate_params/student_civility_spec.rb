RSpec.describe ValidateParams::StudentCivility, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      family_name:,
      first_name:,
      birthday_date:,
      birthday_place:,
      gender:,
      user_id:
    }
  end

  let(:family_name) { 'Dupont' }
  let(:first_name) { 'Jean' }
  let(:birthday_date) { '2000-01-01' }
  let(:birthday_place) { 'Paris' }
  let(:gender) { 'm' }

  let(:user_id) { SecureRandom.uuid }

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
  end

  context 'without birthday place' do
    let(:birthday_place) { '' }

    it { is_expected.to be_a_success }
  end

  context 'without first names' do
    let(:first_name) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(::UnprocessableEntityError)) }
  end

  context 'without family name' do
    let(:family_name) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(::UnprocessableEntityError)) }
  end

  context 'with invalid gender' do
    let(:gender) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(::UnprocessableEntityError)) }
  end

  context 'with invalid birthday date' do
    let(:birthday_date) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(::UnprocessableEntityError)) }
  end
end
