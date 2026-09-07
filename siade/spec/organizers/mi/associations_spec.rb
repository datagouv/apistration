RSpec.describe MI::Associations, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        id:
      }
    end

    context 'with valid siret' do
      let(:id) { valid_siret(:rna) }

      before { stub_mi_associations_valid_siret }

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end

    context 'with valid rna_id' do
      let(:id) { valid_rna_id }

      before { stub_mi_associations_valid_rna }

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end

    context 'with invalid rna_id' do
      let(:id) { invalid_rna_id }

      it { is_expected.to be_a_failure }
    end
  end
end
