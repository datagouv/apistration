RSpec.describe ServiceUser::ValidateBirthDate, type: :validate_params do
  subject { described_class.call(params: { birth_date: }) }

  context 'with valid birth_date' do
    let(:birth_date) { '2000-01-01' }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when birth_date is empty' do
    let(:birth_date) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when birth_date has an invalid format' do
    let(:birth_date) { '2000-01-001' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when birth_date is an invalid date' do
    let(:birth_date) { '2000-16-01' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
