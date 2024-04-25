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

    before do
      stub_request(:get, query_url).to_return(
        status: 200,
        body: open_payload_file('insee/succession_valid.json')
      )
    end

    context 'with a valid siret' do
      let(:siret) { valid_siret }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
