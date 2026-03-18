RSpec.describe API::V2::AttestationsSocialesACOSSController, type: :controller do
  it_behaves_like 'unauthorized'
  it_behaves_like 'unprocessable_entity'
  it_behaves_like 'forbidden'
  it_behaves_like 'ask_for_mandatory_parameters'

  let(:user)  { yes_jwt_user }
  let(:token) { yes_jwt }

  context 'when siren is unknonw from ACOSS', vcr: { cassette_name: 'acoss/with_non_existent_siren' } do
    let(:siren) { non_existent_siren }

    before do
      get :show, params: { token: token, siren: siren }.merge(mandatory_params)
    end

    its(:status) { is_expected.to eq(404) }

    it 'returns 404 with error message' do
      json = JSON.parse(response.body)

      expect(json).to have_json_error(
        detail: "Siren invalide, l'ACOSS ne peut délivrer d'attestation (erreur: Le siren est inconnu du SI Attestations, radié ou hors périmètre Code d'erreur ACOSS : FUNC517)",
      )
    end
  end

  context 'incident: catch FUNC502 into 503', skip: 'Test kept for history, not reproductible with new API', vcr: { cassette_name: 'non_regenerable/attestations_sociales_acoss_incident_534568829' } do
    let(:siren) { '534568829' }

    before do
      get :show, params: { token: token, siren: siren}.merge(mandatory_params)
    end

    its(:status) { is_expected.to eq(503) }

    it 'returns 503 with error message' do
      json = JSON.parse(response.body)
      expect(json['errors']).to include("L'ACOSS ne peut répondre à votre requête, réessayez ultérieurement (erreur: La situation du compte ne permet pas de delivrer l'attestation demandee.)")
    end
  end

  describe "happy path", vcr: { cassette_name: 'acoss/with_valid_siren' } do
    it_behaves_like 'happy_pdf_endpoint_siren', valid_siren(:acoss), 'attestation_vigilance_acoss'
  end

  it 'forwards parameters to ACOSS', vcr: { cassette_name: 'acoss/with_valid_siren' } do
    expect(SIADE::V2::Retrievers::AttestationsSocialesACOSS)
      .to receive(:new)
      .with(siren: valid_siren(:acoss),
        type_attestation: nil,
        user_id: user.logstash_id,
        recipient: mandatory_params[:recipient])
      .and_call_original
    get :show, params: { token: token, siren: valid_siren(:acoss) }.merge(mandatory_params)
  end

  it 'sends a body with the expected payload', vcr: { cassette_name: 'acoss/with_valid_siren' } do
    expect(SIADE::V2::Requests::AttestationsSocialesACOSS)
      .to receive(:new)
      .with(siren: valid_siren(:acoss), type_attestation: nil, user_id: user.logstash_id, recipient: mandatory_params[:recipient])
      .and_call_original

    get :show, params: { token: token, siren: valid_siren(:acoss) }.merge(mandatory_params)
  end
end
