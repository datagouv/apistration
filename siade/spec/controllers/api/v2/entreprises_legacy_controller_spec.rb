RSpec.describe API::V2::EntreprisesLegacyController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  describe 'the only path' do
    let(:token) { yes_jwt }
    let(:siren) { valid_siren(:insee_entreprise_legacy) }

    before do
      get :show, params: { siren: siren, token: token }.merge(mandatory_params)
    end

    it 'returns 404' do
      expect(response.code).to eq('404')
    end

    it 'returns a deprecation message' do
      expect(response_json).to have_json_error(
        detail: 'Les anciennes API de l\'INSEE ont été décomissionnées et cet endpoint n\'est plus disponible. Merci d\'appeler /v2/entreprises/ comme indiqué dans la documentation https://entreprise.api.gouv.fr/catalogue/#entreprises pour obtenir les informations d\'une entreprise.'
      )
    end
  end
end
