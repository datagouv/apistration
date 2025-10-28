RSpec.describe 'Mocking in staging for each routes' do
  before do
    allow(Rails.env).to receive(:staging?).and_return(true)
    allow(MockDataBackend).to receive(:get_response_for).and_return(nil)

    Rack::Attack.reset!
  end

  describe 'API Entreprise', api: :entreprise do
    describe 'v3 and more endpoint' do
      it 'renders a 200' do
        get "/v3/ministere_interieur/rna/associations/#{valid_siret}", params: { token: yes_jwt }.merge(api_entreprise_mandatory_params)

        assert_response :ok
      end
    end
  end

  describe 'API Particulier', api: :particulierv2 do
    before do
      allow(MockDataBackend).to receive(:get_not_found_response_for).and_return(
        {
          status: 404,
          payload: {
            error: 'Not found'
          }
        }
      )
    end

    {
      '/api/v2/situations-pole-emploi' => {
        'identifiant' => '1234567890'
      },
      '/api/v2/etudiants' => {
        'ine' => '1234567890G'
      },
      '/api/v2/etudiants-boursiers' => {
        'ine' => '1234567890G'
      },
      '/api/v2/scolarites' => {
        'nom' => 'DUPONT',
        'prenom' => 'Jean',
        'sexe' => 'm',
        'dateNaissance' => '1980-01-01',
        'codeEtablissement' => '1234567A',
        'anneeScolaire' => '2019-2020'
      }
    }.each do |path, params|
      it "works for #{path} by rendering 404 by default" do
        get path, params: { token: yes_jwt }.merge(params)
        assert_response :not_found
      end
    end

    it 'works for /api/ping by rendering a 200' do
      get '/api/ping'
      assert_response :ok
    end
  end
end
