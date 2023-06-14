RSpec.describe APIEntreprise::V2::EffectifsMensuelsEtablissementACOSSCovidController, type: :controller do
  let(:token) { yes_jwt }
  let(:mois) { '11' }
  let(:annee) { '2020' }
  let(:siret) { valid_siret }

  before do
    Timecop.freeze

    mock_gip_mds_authenticate
  end

  after do
    Timecop.return
  end

  it_behaves_like 'unauthorized', :show, mois: '08', annee: '2020'
  it_behaves_like 'ask_for_mandatory_parameters', :show, mois: '08', annee: '2020'

  describe 'show' do
    subject { get :show, params: { siret: siret, mois: mois, annee: annee, token: token }.merge(mandatory_params) }

    describe 'happy path' do
      let(:valid_response) do
        {
          siret: valid_siret,
          annee: ,
          mois: ,
          effectifs_mensuels: 56.78.to_s
        }
      end

      before do
        mock_gip_mds_mensuel_effectifs(siret: valid_siret, year: annee, month: mois)
      end

      it 'returns 200' do
        expect(subject.status).to eq(200)
      end

      it 'has a valid body' do
        expect(subject.body).to eq(valid_response.to_json)
      end
    end
  end
end
