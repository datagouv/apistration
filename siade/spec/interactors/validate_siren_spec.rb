RSpec.describe ValidateSiren, type: :validate_param_interactor do
  describe '#call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        siren: siren
      }
    end

    context 'when siren is valid' do
      let(:siren) { valid_siren }

      it { is_expected.to be_a_success }
    end

    context 'when siren is not valid' do
      let(:siren) { invalid_siren }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end
  end
end
