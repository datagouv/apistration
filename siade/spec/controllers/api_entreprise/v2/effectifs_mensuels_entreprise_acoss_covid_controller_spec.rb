RSpec.describe APIEntreprise::V2::EffectifsMensuelsEntrepriseACOSSCovidController, type: :controller do
  let(:token) { yes_jwt }
  let(:mois) { '11' }
  let(:annee) { '2020' }
  let(:siren) { valid_siren }

  it_behaves_like 'unauthorized', :show, mois: '08', annee: '2020'
  it_behaves_like 'ask_for_mandatory_parameters', :show, mois: '08', annee: '2020'

  describe 'show' do
    subject { get :show, params: { siren: siren, mois: mois, annee: annee, token: token }.merge(mandatory_params) }

    it 'returns 404' do
      expect(subject.status).to eq(404)
    end

    it 'has a valid body' do
      expect(subject.body).to eq({
	      error: "Ce siren ne figure pas dans les données des effectifs mensuels moyens"
      }.to_json)
    end
  end
end
