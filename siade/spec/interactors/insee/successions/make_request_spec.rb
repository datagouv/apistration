RSpec.describe INSEE::Successions::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret:
      }
    end

    let(:query_params) { "q=siretEtablissementSuccesseur:#{siret} OR siretEtablissementPredecesseur:#{siret}" }
    let(:query_url) { "#{Siade.credentials[:insee_v3_domain]}/entreprises/sirene/V3.11/siret/liensSuccession?#{query_params}" }

    before { stub_insee_successions_make_request(siret:) }

    context 'with a valid siret' do
      let(:siret) { valid_siret }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
