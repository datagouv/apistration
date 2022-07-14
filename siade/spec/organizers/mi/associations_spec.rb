RSpec.describe MI::Associations, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret_or_rna:
      }
    end

    context 'with valid siret', vcr: { cassette_name: 'mi/associations/with_valid_siret' } do
      let(:siret_or_rna) { valid_siret(:rna) }

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end

    context 'with valid rna_id', vcr: { cassette_name: 'mi/associations/with_valid_rna' } do
      let(:siret_or_rna) { valid_rna_id }

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end

    context 'with invalid rna_id', vcr: { cassette_name: 'mi/associations/with_invalid_rna' } do
      let(:siret_or_rna) { invalid_rna_id }

      it { is_expected.to be_a_failure }
    end
  end
end
