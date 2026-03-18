RSpec.describe API::V2::EffectifsMensuelsEtablissementACOSSCovidController, type: :controller do
  it_behaves_like 'unauthorized', :show, mois: '08', annee: '2020'
  it_behaves_like 'ask_for_mandatory_parameters', :show, mois: '08', annee: '2020'

  let(:siret) { valid_siret }
  let(:annee) { '2020' }
  let(:mois) { '11' }

  let(:token) { yes_jwt }

  describe 'show' do
    subject { get :show, params: { siret: siret, mois: mois, annee: annee, token: token }.merge(mandatory_params) }

    describe 'happy path' do
      let(:valid_response) do
        {
          siret:              valid_siret,
          annee:              annee,
          mois:               mois,
          effectifs_mensuels: '1.00',
        }
      end

      before do
        stub_request(:get, "http://127.0.0.1/effectifs_mensuels_etablissement/#{siret}/#{annee}/#{mois}").and_return(
          status: 200,
          body:   valid_response.to_json,
        )
      end

      it 'returns 200' do
        expect(subject.status).to eq(200)
      end

      it 'has a valid body' do
        expect(subject.body).to eq(valid_response.to_json)
      end
    end

    describe 'when there is a timeout' do
      let(:timeout_error) do
        [
          Net::OpenTimeout,
          Net::ReadTimeout,
        ].sample
      end

      before do
        stub_request(:get, "http://127.0.0.1/effectifs_mensuels_etablissement/#{siret}/#{annee}/#{mois}").to_raise(timeout_error)
      end

      it 'returns 502' do
        expect(subject.status).to eq(502)
      end

      it 'has an error body' do
        expect(JSON.parse(subject.body)).to have_json_error(
          detail: 'Le service intermédiaire n\'a pas répondu',
        )
      end
    end
  end
end
