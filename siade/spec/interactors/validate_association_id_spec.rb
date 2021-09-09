RSpec.describe ValidateAssociationId, type: :validate_param_interactor do
  describe '#call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        association_id: id,
      }
    end

    describe 'happy path' do
      context 'when valid RNA id' do
        let(:id) { valid_rna_id }

        it { is_expected.to be_a_success }
      end

      context 'when valid Siret' do
        let(:id) { valid_siret }

        it { is_expected.to be_a_success }
      end
    end

    describe 'unhappy path' do
      context 'when valid RNA id' do
        let(:id) { invalid_rna_id }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to be_present }
      end
    end
  end
end
