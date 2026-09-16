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

    context 'with valid siret' do
      let(:limit) { nil }

      let(:siret) { valid_siret(:rge_ademe) }

      before { stub_ademe_valid_siret }

      it { is_expected.to be_a_success }

      it 'retrieves the resource collection' do
        expect(resource_collection).to be_present
      end

      describe 'with limit param' do
        let(:limit) { 2 }

        before { stub_ademe_valid_siret_with_limit }

        it 'paginates according to the limit params' do
          expect(resource_collection.size).to eq(limit)
        end
      end
    end
  end
end
