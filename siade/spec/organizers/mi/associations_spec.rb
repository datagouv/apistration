RSpec.describe MI::Associations, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        id: id
      }
    end

    context 'with valid siret', vcr: { cassette_name: 'mi/associations/valid_siret_json' } do
      let(:id) { valid_siret(:rna) }

      it { is_expected.to be_a_success }

      its(:resource) { is_expected.to be_present }
    end

    context 'with valid rna_id', vcr: { cassette_name: 'mi/associations/valid_rna_json' } do
      let(:id) { valid_rna_id }

      it { is_expected.to be_a_success }

      its(:resource) { is_expected.to be_present }
    end

    context 'with invalid rna_id', vcr: { cassette_name: 'mi/associations/invalid_siret_json' } do
      let(:id) { invalid_rna_id }

      it { is_expected.to be_a_failure }
    end
  end
end
