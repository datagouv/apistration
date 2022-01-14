RSpec.describe API::V2::ExercicesController, type: :controller do
  before do
    allow_any_instance_of(AuthenticateDGFIPService).to receive(:authenticate!)
    allow_any_instance_of(AuthenticateDGFIPService).to receive(:success?).and_return(true)
    allow_any_instance_of(AuthenticateDGFIPService).to receive(:cookie).and_return('valid_cookie')
    # Imperative to have a persistant user_id in VCR cassettes
    allow(UserIdDGFIPService).to receive(:call).and_return(valid_dgfip_user_id)
  end

  it_behaves_like 'unauthorized'
  it_behaves_like 'forbidden'
  it_behaves_like 'unprocessable_entity', :show, :siret
  it_behaves_like 'ask_for_mandatory_parameters'

  describe 'happy path' do
    let(:response_body) do
      json = JSON.parse(response.body, symbalize_names: true)
    end

    context 'when user authenticates with valid token' do
      let(:token) { yes_jwt }

      context 'when siret is not found', vcr: { cassette_name: 'dgfip/chiffres_affaires/not_found' } do
        it_behaves_like 'not_found'
      end

      context 'when siret triggers a 302 error from DGFIP (non-regression test)', vcr: { cassette_name: 'dgfip/chiffres_affaires/redirect' } do
        let(:siret) { out_of_scope_dgfip }

        before do
          get :show, params: { siret: siret, token: token, user_id: valid_dgfip_user_id }.merge(mandatory_params)
        end

        it 'returns 502' do
          expect(response.code.to_i).to eq 502
        end

        it 'returns an actionable error message' do
          expect(response_body).to have_json_error(detail: 'Erreur de la DGFIP, celle intervient généralement lorsque l\'organisme n\'est pas soumis à l\'impôt sur les sociétés. Si c\'est bien le cas il est possible que les comptes n\'est pas encore été déposés aux greffes.')
        end
      end

      context 'when siret is found', vcr: { cassette_name: 'dgfip/chiffres_affaires/valid' } do
        before do
          get :show, params: { siret: siret, token: token, user_id: valid_dgfip_user_id }.merge(mandatory_params)
        end

        let(:siret) { valid_siret(:exercice) }

        it 'returns 200' do
          expect(response.code.to_i).to eq 200
        end

        context 'global response' do
          subject { response_body }

          its(['exercices']) { is_expected.to be_a_kind_of Array }

          describe '#exercices.first' do
            subject { response_body['exercices'].first }

            it { is_expected.to be_a_kind_of Hash }
            its(['ca']) { is_expected.to eq '648374448' }
            its(['date_fin_exercice']) { is_expected.to eq '2016-12-31T00:00:00+01:00' }
            its(['date_fin_exercice_timestamp']) { is_expected.to eq 1_483_138_800 }
          end
        end
      end
    end
  end
end
