RSpec.describe API::V2::CertificatsRGEADEMEController do
  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity', :show, :siret
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  context 'siret inconnu chez ADEME', vcr: { cassette_name: 'ademe/certificats_rge/not_found_siret' } do
    subject { response }

    let(:token) { yes_jwt }
    let(:siret) { not_found_siret(:rge_ademe) }

    before do
      get :show, params: { siret:, token: }.merge(mandatory_params)
    end

    its(:status) { is_expected.to eq(404) }

    it 'returns 404 error message' do
      json = JSON.parse(response.body)

      expect(json).to have_json_error(detail: "Le siret indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel.")
    end
  end

  describe '#show' do
    before do
      get :show, params: { siret: siret, token: token }.merge(mandatory_params)
    end

    let(:response_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    context 'when user authenticate with valid token' do
      let(:token) { yes_jwt }

      context 'siret connu de l\'ADEME', vcr: { cassette_name: 'ademe/certificats_rge/valid_siret' } do
        subject { response_body }

        let(:siret) { valid_siret(:rge_ademe) }

        it 'returns HTTP code 200' do
          expect(response).to have_http_status(:ok)
        end

        its([:qualifications]) do
          is_expected.to include(a_hash_including({
            nom: 'Qualisol - Pose de chauffe-eau solaire individuel (eau chaude solaire) (11)',
            url_certificat: 'http://www.qualypso.fr/download_file.php?id=782bc8d4-70ac-4fda-a5cc-1caade920b76',
            nom_certificat: 'Qualisol CESI'
          }))
        end

        its([:domaines]) do
          is_expected.to include('Chauffage et/ou eau chaude solaire')
        end
      end
    end
  end
end
