RSpec.describe CNOUS::StudentScholarshipWithCivility::ValidateBirthdayDate, type: :validate_params do
  subject { described_class.call(params: { birthday_date: }) }

  context 'with valid birthday_date' do
    let(:birthday_date) { '2000-01-01' }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when birthday_date is empty' do
    let(:birthday_date) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when birthday_date has an invalid format' do
    let(:birthday_date) { '2000-01-001' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
