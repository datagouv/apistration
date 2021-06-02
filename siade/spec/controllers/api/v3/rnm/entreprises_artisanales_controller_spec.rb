RSpec.describe API::V3::RNM::EntreprisesArtisanalesController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  describe '#show' do
    before do
      get :show, params: { siren: siren, token: token }.merge(mandatory_params)
    end

    after do
      expect(response.content_type).to start_with('application/vnd.api+json')
    end

    context 'when user authenticate with valid token' do
      let(:token) { yes_jwt }

      xcontext 'with invalid siren' do
        let(:siren) { invalid_siren }

        its(:status) { is_expected.to eq(422) }

        it 'returns an error message' do
          expect(response_json).to include({
            errors: ['Le numéro siren indiqué n\'est pas correctement formatté']
          })
        end
      end

      xcontext 'with unknown siren', vcr: { cassette_name: 'rnm_cma/not_found_siren' } do
        let(:siren) { not_found_siren(:rnm_cma) }

        its(:status) { is_expected.to eq(404) }

        it 'returns an error message' do
          expect(response_json).to include({
            errors: ['Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel']
          })
        end
      end

      context 'with valid and known siren', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
        let(:siren) { valid_siren(:rnm_cma) }

        it 'returns HTTP code 200'  do
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
