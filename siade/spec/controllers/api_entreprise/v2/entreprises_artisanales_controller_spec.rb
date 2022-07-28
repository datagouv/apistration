RSpec.describe APIEntreprise::V2::EntreprisesArtisanalesController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity'
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  describe '#show' do
    before do
      get :show, params: { siren: siren, token: token }.merge(mandatory_params).merge(format: format).compact
    end

    let(:format) { nil }

    context 'when user authenticate with valid token' do
      let(:token) { yes_jwt }

      context 'with unknown siren', vcr: { cassette_name: 'rnm_cma/not_found_siren' } do
        let(:siren) { not_found_siren(:rnm_cma) }

        its(:status) { is_expected.to eq(404) }

        it 'returns an error message' do
          expect(response_json).to have_json_error(
            detail: 'Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel'
          )
        end
      end

      context 'with valid and known siren' do
        let(:siren) { valid_siren(:rnm_cma) }

        context 'without format', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
          it 'returns HTTP code 200' do
            expect(response).to have_http_status(:ok)
          end
        end
      end
    end
  end
end
