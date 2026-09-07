RSpec.describe ADEME::CertificatsRGE::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret:,
        limit: 1_000
      }
    end

    context 'with a valid siret' do
      let(:siret) { valid_siret(:rge_ademe) }

      before { stub_ademe_valid_siret }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
