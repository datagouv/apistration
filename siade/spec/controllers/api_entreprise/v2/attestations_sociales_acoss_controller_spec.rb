RSpec.describe APIEntreprise::V2::AttestationsSocialesACOSSController, type: :controller do
  let(:token) { yes_jwt }
  let(:user)  { yes_jwt_user }

  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity'
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  context 'when siren is unknonw from ACOSS', vcr: { cassette_name: 'acoss/with_non_existent_siren' } do
    let(:siren) { non_existent_siren }

    before do
      get :show, params: { token: token, siren: siren }.merge(mandatory_params)
    end

    its(:status) { is_expected.to eq(404) }

    it 'returns 404 with error message' do
      json = JSON.parse(response.body)

      expect(json).to have_json_error(
        detail: "Siren invalide, l'ACOSS ne peut délivrer d'attestation (erreur: Le siren est inconnu du SI Attestations, radié ou hors périmètre Code d'erreur ACOSS : FUNC517)"
      )
    end
  end

  describe 'happy path', vcr: { cassette_name: 'acoss/with_valid_siren' } do
    it_behaves_like 'happy_pdf_endpoint_siren', valid_siren(:acoss), 'attestation_vigilance_acoss'
  end
end
