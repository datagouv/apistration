RSpec.describe ValidateSiretOrRNA, type: :validate_param_interactor do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        siret_or_rna: siret_or_rna
      }
    end

    context 'when it is a valid RNA id' do
      let(:siret_or_rna) { valid_rna_id }

      it { is_expected.to be_a_success }
    end

    context 'when it is a valid Siret' do
      let(:siret_or_rna) { valid_siret }

      it { is_expected.to be_a_success }
    end

    context 'when it is an invalid RNA id' do
      let(:siret_or_rna) { invalid_rna_id }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is an invalid siret' do
      let(:siret_or_rna) { invalid_siret }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is nil' do
      let(:siret_or_rna) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is an empty id' do
      let(:siret_or_rna) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is random text' do
      let(:siret_or_rna) { 'random text' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end
  end
end
