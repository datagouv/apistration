RSpec.describe APIEntreprise::V2::CotisationsMSAController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity', :show, :siret
  # TODO: Alexis VCR errors ???
  # it_behaves_like 'not_found', not_found_siret(:msa)
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  # WARNING
  # These cassettes cannot be easly regenerated (siret are not referenced in msa anymore) just checkout the old cassette...
  describe 'happy path #show' do
    subject { JSON.parse(response.body) }

    let(:token) { yes_jwt }

    before { get :show, params: { siret: siret, token: token }.merge(mandatory_params) }

    context 'analyse_en_cours is true', vcr: { cassette_name: 'non_regenerable/msa_web_service_cotisation_pending_siret' } do
      let(:siret) { valid_siret(:msa_pending) }

      it 'returns 200 with analyse_en_cours at true' do
        expect(response).to have_http_status(:ok)
        expect(subject['analyse_en_cours']).to be_truthy
      end
    end

    context 'analyse_en_cours is false', vcr: { cassette_name: 'non_regenerable/msa_web_service_cotisation_valid_siret' } do
      let(:siret) { valid_siret(:msa) }

      it 'returns 200 with analyse_en_cours at false' do
        expect(response).to have_http_status(:ok)
        expect(subject['analyse_en_cours']).to be false
      end
    end
  end
end
