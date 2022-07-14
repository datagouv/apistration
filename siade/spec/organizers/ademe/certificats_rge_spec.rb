RSpec.describe ADEME::CertificatsRGE, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret:,
        limit:
      }
    end

    let(:resource_collection) { subject.bundled_data.data }

    context 'with valid siret', vcr: { cassette_name: 'ademe/certificats_rge/valid_siret' } do
      let(:limit) { nil }

      let(:siret) { valid_siret(:rge_ademe) }

      it { is_expected.to be_a_success }

      it 'retrieves the resource collection' do
        expect(resource_collection).to be_present
      end

      describe 'with limit param', vcr: { cassette_name: 'ademe/certificats_rge/valid_siret_with_limit' } do
        let(:limit) { 2 }

        it 'paginates according to the limit params' do
          expect(resource_collection.size).to eq(limit)
        end
      end
    end
  end
end
