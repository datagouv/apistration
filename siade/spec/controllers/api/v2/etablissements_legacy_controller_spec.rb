RSpec.describe API::V2::EtablissementsLegacyController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  describe 'the only path' do
    let(:token) { yes_jwt }
    let(:siret) { valid_siret(:octo) }

    before do
      get :show, params: { siret: siret, token: token }.merge(mandatory_params)
    end

    it 'returns 410' do
      expect(response.code).to eq('410')
    end

    it 'returns a deprecation message' do
      expect(response_json).to have_json_error(
        detail: 'Les anciennes API de l\'INSEE ont été décomissionnées et cet endpoint n\'est plus disponible. Merci d\'appeler /v2/etablissements/ comme indiqué dans la documentation https://entreprise.api.gouv.fr/catalogue/#etablissements pour obtenir les informations d\'un établissement.'
      )
    end
  end
end
