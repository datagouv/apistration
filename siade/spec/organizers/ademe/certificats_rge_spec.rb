RSpec.describe ADEME::CertificatsRGE, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret:,
        size: 10_000
      }
    end

    context 'with valid siret', vcr: { cassette_name: 'ademe/certificats_rge/valid_siret' } do
      let(:siret) { valid_siret(:rge_ademe) }

      it { is_expected.to be_a_success }

      its(:resource) { is_expected.to be_present }
    end
  end
end
