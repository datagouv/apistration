RSpec.describe ValidateAssociationId, type: :validate_param_interactor do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        id: id
      }
    end

    context 'when it is a valid RNA id' do
      let(:id) { valid_rna_id }

      it { is_expected.to be_a_success }
    end

    context 'when it is a valid Siret' do
      let(:id) { valid_siret }

      it { is_expected.to be_a_success }
    end

    context 'when it is an invalid RNA id' do
      let(:id) { invalid_rna_id }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is an invalid siret' do
      let(:id) { invalid_siret }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is nil' do
      let(:id) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is an empty id' do
      let(:id) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end

    context 'when it is random text' do
      let(:id) { 'random text' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to be_present }
    end
  end
end
