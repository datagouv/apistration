RSpec.describe ValidateMonth, type: :validate_param_interactor do
  describe '#call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        month:
      }
    end

    context 'when month is valid' do
      let(:month) { '02' }

      it { is_expected.to be_a_success }
    end

    context 'when month is not valid' do
      let(:month) { '1' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end
  end
end
