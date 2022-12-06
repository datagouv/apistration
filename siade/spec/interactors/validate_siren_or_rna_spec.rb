RSpec.describe ValidateSirenOrRNA, type: :validate_param_interactor do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren_or_rna:
      }
    end

    context 'when it is a valid RNA id' do
      let(:siren_or_rna) { valid_rna_id }

      it { is_expected.to be_a_success }
    end

    context 'when it is a valid siren' do
      let(:siren_or_rna) { valid_siren }

      it { is_expected.to be_a_success }
    end

    context 'when it is an invalid RNA id' do
      let(:siren_or_rna) { invalid_rna_id }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is an invalid siren' do
      let(:siren_or_rna) { invalid_siren }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is nil' do
      let(:siren_or_rna) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is an empty id' do
      let(:siren_or_rna) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is random text' do
      let(:siren_or_rna) { 'random text' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end
  end
end
