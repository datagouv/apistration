RSpec.describe APIParticulier::V2::CNOUS::StudentScholarshipController do
  let(:all_cnous_scopes) { %w[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_statut_bourse cnous_periode_versement cnous_ville_etudes] }
  let(:one_field_of_each_scope) { %w[nom email boursier echelonBourse statut dateDeRentree villeEtudes] }

  let(:token) { TokenFactory.new(scopes).valid }
  let(:ine) { '1234567890G' }

  before do
    mock_cnous_authenticate
  end

  describe 'with ine param' do
    subject { get :show, params: { ine:, token: } }

    before do
      affect_scopes_to_yes_jwt_token(scopes)
    end

    after(:all) do
      reset_yes_jwt_token_scopes!
    end

    describe 'with valid params' do
      before do
        mock_cnous_valid_call('ine')
      end

      context 'when token has full access' do
        let(:scopes) { all_cnous_scopes }

        its(:status) { is_expected.to eq(200) }

        it 'returns all fields' do
          json = JSON.parse(subject.body)

          one_field_of_each_scope.each do |key|
            expect(json).to have_key(key), "#{key} is missing"
          end
        end
      end

      context 'when cnous_email is missing' do
        let(:scopes) { all_cnous_scopes - %w[cnous_email] }

        it 'does not return field email' do
          json = JSON.parse(subject.body)

          (one_field_of_each_scope - %w[email]).each do |key|
            expect(json).to have_key(key), "#{key} is missing"
          end

          expect(json).not_to have_key('email')
        end
      end
    end

    describe 'when it is a 404' do
      let(:scopes) { all_cnous_scopes }

      before do
        stub_request(:get, /#{Siade.credentials[:cnous_student_scholarship_ine_url]}/).to_return(
          status: 404,
          body: read_payload_file('cnous/student_scholarship_not_found.json')
        )
      end

      its(:status) { is_expected.to eq(404) }

      its(:body) do
        is_expected.to eq({
          error: 'not_found',
          reason: 'Scholarship not found',
          message: "Aucun étudiant boursier n'a pu être trouvé avec les critères de recherche fournis Veuillez vérifier que votre recherche est couverte par le périmètre de l'API."
        }.to_json)
      end
    end
  end

  describe 'with civility params' do
    subject { get :show, params: { nom:, prenoms:, dateDeNaissance:, lieuDeNaissance:, sexe:, token: }.compact }

    # rubocop:disable RSpec/VariableName
    let(:nom) { 'Dupont' }
    let(:prenoms) { 'Jean Charlie' }
    let(:dateDeNaissance) { '2000-01-01' }
    let(:lieuDeNaissance) { 'Paris' }
    let(:sexe) { 'M' }
    # rubocop:enable RSpec/VariableName

    describe 'with valid params' do
      before do
        mock_cnous_valid_call('civility')
      end

      context 'when token has full access' do
        let(:scopes) { all_cnous_scopes }

        its(:status) { is_expected.to eq(200) }

        it 'returns all fields' do
          json = JSON.parse(subject.body)

          one_field_of_each_scope.each do |key|
            expect(json).to have_key(key), "#{key} is missing"
          end
        end
      end
    end

    describe 'without prenoms (non regression test)' do
      before do
        mock_cnous_valid_call('civility')
      end

      let(:scopes) { all_cnous_scopes }
      let(:prenoms) { nil }

      its(:status) { is_expected.to eq(400) }
    end

    describe 'when it is a 409' do
      let(:scopes) { all_cnous_scopes }

      before do
        stub_request(:post, /#{cnous_url_for('civility')}/).to_return(
          status: 200,
          body: [cnous_valid_payload('civility'), cnous_valid_payload('civility')].to_json
        )
      end

      its(:status) { is_expected.to eq(409) }
    end

    describe 'without dateDeNaissance (non regression test)' do
      before do
        mock_cnous_valid_call('civility')
      end

      let(:scopes) { all_cnous_scopes }
      # rubocop:disable RSpec/VariableName
      let(:dateDeNaissance) { nil }
      # rubocop:enable RSpec/VariableName

      its(:status) { is_expected.to eq(400) }
    end
  end

  describe 'with france connect token' do
    subject(:make_call) do
      request.headers['Authorization'] = 'Bearer france_connect_token'

      get :show, params:
    end

    let(:recipient) { valid_siret(:recipient) }
    let(:params) { default_france_connect_identity_attributes.merge(recipient:) }

    before do
      allow(CNOUS::StudentScholarshipWithFranceConnect).to receive(:call).and_call_original

      mock_cnous_valid_call('france_connect')

      mock_valid_france_connect_checktoken(scopes: minimal_france_connect_scopes.split.concat(all_cnous_scopes).join(' '))
    end

    its(:status) { is_expected.to eq(200) }

    it 'returns all fields' do
      json = JSON.parse(subject.body)

      one_field_of_each_scope.each do |key|
        expect(json).to have_key(key), "#{key} is missing"
      end
    end

    it 'calls CNOUS::StudentScholarshipWithFranceConnect with france connect person identity attributes' do
      make_call

      expect(CNOUS::StudentScholarshipWithFranceConnect).to have_received(:call)
    end

    describe 'when recipient is missing' do
      let(:params) { default_france_connect_identity_attributes.merge(recipient: nil) }

      its(:status) { is_expected.to eq(400) }

      its(:body) do
        is_expected.to eq({
          error: 'bad_request',
          reason: "Le paramètre recipient n'est pas un siret valide",
          message: "Le paramètre recipient n'est pas un siret valide"
        }.to_json)
      end
    end
  end
end
