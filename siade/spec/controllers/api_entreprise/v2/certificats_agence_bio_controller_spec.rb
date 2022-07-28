RSpec.describe APIEntreprise::V2::CertificatsAgenceBIOController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity', :show, :siret
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  describe 'happy path' do
    subject { get :show, params: { siret: valid_siret(:agence_bio), token: token }.merge(mandatory_params) }

    let(:token) { yes_jwt }

    context 'when siret is not found', vcr: { cassette_name: 'agence_bio/with_not_found_siret' } do
      it_behaves_like 'not_found', siret: not_found_siret(:agence_bio)
    end

    context 'when siret is valid', vcr: { cassette_name: 'agence_bio/with_valid_siret' } do
      let(:json_body) { JSON.parse(response.body) }
      let(:infos_entreprise) { json_body.first }

      it 'returns HTTP code 200' do
        subject

        expect(response).to have_http_status(:ok)
      end

      it 'return body with valid format' do
        subject

        expect(json_body).to be_an(Array)
      end

      it 'return body with valid information' do

        subject

        expect(infos_entreprise['siret']).to eq(valid_siret(:agence_bio))
        expect(infos_entreprise['activites']).to eq(['Préparation'])
        expect(infos_entreprise['numero_bio']).to eq(15_727)
      end
    end
  end
end

