RSpec.describe APIParticulier::V2::PoleEmploi::StatutController do
  subject { get :show, params: { identifiant:, token: } }

  let(:all_france_travail_scopes) { %i[pole_emploi_identite pole_emploi_adresse pole_emploi_contact pole_emploi_inscription] }
  let(:one_field_of_each_scope) { %w[civilite adresse email dateInscription] }

  let(:token) { TokenFactory.new(scopes).valid }
  let(:identifiant) { 'whatever' }

  describe 'with valid params', vcr: { cassette_name: 'france_travail/oauth2' } do
    before do
      stub_request(:post, Siade.credentials[:france_travail_status_url]).and_return(
        status: 200,
        body: read_payload_file('france_travail/statut/valid.json')
      )

      affect_scopes_to_yes_jwt_token(scopes)
    end

    after(:all) do
      reset_yes_jwt_token_scopes!
    end

    context 'when token has full access' do
      let(:scopes) { all_france_travail_scopes }

      its(:status) { is_expected.to eq(200) }

      it 'returns all fields' do
        json = JSON.parse(subject.body)

        one_field_of_each_scope.each do |key|
          expect(json).to have_key(key), "#{key} is missing"
        end
      end

      it 'returns correct identifiant' do
        json = JSON.parse(subject.body)

        expect(json['identifiant']).to eq(identifiant)
      end
    end

    context 'when france_travail_identite is missing' do
      let(:scopes) { all_france_travail_scopes - %i[pole_emploi_identite] }

      it 'does not return this field' do
        json = JSON.parse(subject.body)

        (one_field_of_each_scope - ['civilite']).each do |key|
          expect(json).to have_key(key), "#{key} is missing"
        end

        expect(json).not_to have_key('civilite')
      end
    end
  end

  describe 'when it is a 404', vcr: { cassette_name: 'france_travail/oauth2' } do
    let(:scopes) { all_france_travail_scopes }

    before do
      stub_request(:post, Siade.credentials[:france_travail_status_url]).and_return(
        status: 404,
        body: read_payload_file('france_travail/statut/not_found.json')
      )
    end

    its(:status) { is_expected.to eq(404) }

    its(:body) do
      is_expected.to eq({
        error: 'not_found',
        reason: 'Situation not found',
        message: 'Aucune situation France Travail n\'a pu être trouvée avec les critères de recherche fournis Veuillez vérifier que votre recherche est couverte par le périmètre de l\'API.'
      }.to_json)
    end
  end
end
