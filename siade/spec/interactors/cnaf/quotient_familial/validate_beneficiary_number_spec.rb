RSpec.describe CNAF::QuotientFamilial::ValidateBeneficiaryNumber, type: :validate_param_interactor do
  subject { described_class.call(params: { beneficiary_number: }) }

  context 'when attribute is missing' do
    let(:beneficiary_number) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when attribute is present' do
    context 'when it is 7 digits' do
      let(:beneficiary_number) { '1234567' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is 6 digits' do
      let(:beneficiary_number) { '123456' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is 5 digits' do
      let(:beneficiary_number) { '12345' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is 5 chars non digit' do
      let(:beneficiary_number) { '1234a' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is 4 digits' do
      let(:beneficiary_number) { '1234' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is 8 digits' do
      let(:beneficiary_number) { '12345678' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end
end
