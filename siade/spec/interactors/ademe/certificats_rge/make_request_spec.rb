RSpec.describe ADEME::CertificatsRGE::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret:,
        limit: 1_000
      }
    end

    context 'with a valid siret', vcr: { cassette_name: 'ademe/certificats_rge/valid_siret' } do
      let(:siret) { valid_siret(:rge_ademe) }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
