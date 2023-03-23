RSpec.describe CNOUS::StudentScholarshipWithCivility::ValidateParams, type: :validate_params do
  subject { described_class.call(params:) }

  let(:params) do
    {
      family_name:,
      first_names:,
      birth_date:,
      birth_place:,
      gender:
    }
  end

  let(:family_name) { 'Dupont' }
  let(:first_names) { 'Jean Charlie' }
  let(:birth_date) { '2000-01-01' }
  let(:birth_place) { 'Paris' }
  let(:gender) { 'M' }

  context 'with valid attributes' do
    it { is_expected.to be_a_success }
  end

  context 'without first name' do
    let(:first_names) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'without family name' do
    let(:family_name) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'with invalid birthday date' do
    let(:birth_date) { 'lol' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
