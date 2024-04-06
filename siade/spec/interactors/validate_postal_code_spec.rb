RSpec.describe ValidatePostalCode, type: :validate_param_interactor do
  subject { described_class.call(params: { postal_code: }) }

  context 'when attribute is missing' do
    let(:postal_code) { nil }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end

  context 'when attribute is present' do
    context 'when it is 5 digits (string)' do
      let(:postal_code) { '75001' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is 5 digits (integer)' do
      let(:postal_code) { 75_001 }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is 5 chars non digit' do
      let(:postal_code) { '7A001' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is 6 digits' do
      let(:postal_code) { '750010' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is 4 digits' do
      let(:postal_code) { '7500' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end
end
