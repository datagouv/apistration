RSpec.describe SIADE::V2::Responses::BilansEntreprisesBDF, type: :provider_response do
  subject { SIADE::V2::Requests::BilansEntreprisesBDF.new(siren).perform.response }

  context 'BDF app returns 200 and embeds true http code into json field' do
    context 'we return 404 when siren does not exist', vcr: { cassette_name: 'banque_de_france/bilans_entreprises/not_found_siren' } do
      let(:siren) { non_existent_siren }

      its(:'raw_response.code')       { is_expected.to eq(200) }
      its(:http_code)                 { is_expected.to eq(404) }
      its(:raw_functionnal_http_code) { is_expected.to eq(204) }
      its(:errors)                    { is_expected.to have_error("Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel") }
    end

    context 'we return 404 when siren exists but has no data', vcr: { cassette_name: 'banque_de_france/bilans_entreprises/no_data_siren' } do
      let(:siren) { '828277871' } # Saturne consulting

      its(:'raw_response.code')       { is_expected.to eq(200) }
      its(:http_code)                 { is_expected.to eq(404) }
      its(:raw_functionnal_http_code) { is_expected.to eq(204) }
      its(:errors)                    { is_expected.to have_error("Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel") }
    end

    context 'we return 503 when their database is out' do
      let(:siren) { valid_siren }

      before do
        stub_request(:get, /ws-dlnuf.banque-france.fr/).to_return(
          status: 200, body: '{ "code-retour": 501 }'
        )
      end

      its(:'raw_response.code')       { is_expected.to eq(200) }
      its(:http_code)                 { is_expected.to eq(503) }
      its(:raw_functionnal_http_code) { is_expected.to eq(501) }
      its(:errors)                    { is_expected.to have_error('Les serveurs de la Banque de France rencontrent une erreur de base de données') }

      include_examples 'provider\'s response error'
    end

    context 'we return 503 when their server has internal server error' do
      let(:siren) { valid_siren }

      before do
        stub_request(:get, /ws-dlnuf.banque-france.fr/).to_return(
          status: 200, body: '{ "code-retour": 500 }'
        )
      end

      its(:'raw_response.code')       { is_expected.to eq(200) }
      its(:http_code)                 { is_expected.to eq(503) }
      its(:raw_functionnal_http_code) { is_expected.to eq(500) }
      its(:errors)                    { is_expected.to have_error('Les serveurs de la Banque de France rencontrent une erreur interne') }

      include_examples 'provider\'s response error'
    end

    context 'we return their functionnal http code otherwise' do
      let(:siren) { valid_siren }
      let(:random_tea_pot_http_code) { 418 }

      before do
        stub_request(:get, /ws-dlnuf.banque-france.fr/).to_return(
          status: 200, body: '{ "code-retour": 418 }'
        )
      end

      its(:'raw_response.code')       { is_expected.to eq(200) }
      its(:http_code)                 { is_expected.to eq(random_tea_pot_http_code) }
      its(:raw_functionnal_http_code) { is_expected.to eq(random_tea_pot_http_code) }
      its(:errors)                    { is_expected.to be_empty }
    end
  end
end
