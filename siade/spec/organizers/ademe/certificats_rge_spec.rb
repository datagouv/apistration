RSpec.describe ADEME::CertificatsRGE, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret:,
        limit:
      }
    end

    context 'with valid siret', vcr: { cassette_name: 'ademe/certificats_rge/valid_siret' } do
      let(:limit) { 10_000 }

      let(:siret) { valid_siret(:rge_ademe) }

      it { is_expected.to be_a_success }

      its(:resource_collection) { is_expected.to be_present }

      describe 'with limit param', vcr: { cassette_name: 'ademe/certificats_rge/valid_siret_with_limit' } do
        subject(:results) { described_class.call(params:).resource_collection }

        let(:limit) { 2 }

        its(:size) { is_expected.to eq(limit) }
      end
    end
  end
end
