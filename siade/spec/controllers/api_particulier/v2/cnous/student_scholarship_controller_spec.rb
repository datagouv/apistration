RSpec.describe APIParticulier::V2::CNOUS::StudentScholarshipController, type: :controller do
  let(:all_scopes) { %w[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_statut_bourse cnous_periode_versement cnous_ville_etudes] }
  let(:one_field_of_each_scope) { %w[nom email boursier echelonBourse statut dateDeRentree villeEtudes] }

  let(:token) { TokenFactory.new(scopes).valid }
  let(:ine) { '1234567890G' }

  before do
    mock_cnous_authenticate
  end

  describe 'with ine param' do
    subject { get :show, params: { ine:, token: } }

    describe 'with valid params' do
      before do
        mock_cnous_valid_call('ine')
      end

      context 'when token has full access' do
        let(:scopes) { all_scopes }

        its(:status) { is_expected.to eq(200) }

        it 'returns all fields' do
          json = JSON.parse(subject.body)

          one_field_of_each_scope.each do |key|
            expect(json).to have_key(key), "#{key} is missing"
          end
        end
      end

      context 'when cnous_email is missing' do
        let(:scopes) { all_scopes - %w[cnous_email] }

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
      let(:scopes) { all_scopes }

      before do
        stub_request(:get, /#{Siade.credentials[:cnous_student_scholarship_ine_url]}/).to_return(
          status: 404,
          body: Rails.root.join('spec/fixtures/payloads/cnous_student_scholarship_not_found.json').read
        )
      end

      its(:status) { is_expected.to eq(404) }

      its(:body) do
        is_expected.to eq({
          error: 'not_found',
          reason: 'Student situation not found',
          message: "Impossible de trouver la situation de l'étudiant correspondant à la recherche"
        }.to_json)
      end
    end
  end

  describe 'with civility params' do
    subject { get :show, params: { nom:, prenoms:, dateDeNaissance:, lieuDeNaissance:, sexe:, token: } }

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
        let(:scopes) { all_scopes }

        its(:status) { is_expected.to eq(200) }

        it 'returns all fields' do
          json = JSON.parse(subject.body)

          one_field_of_each_scope.each do |key|
            expect(json).to have_key(key), "#{key} is missing"
          end
        end
      end
    end
  end

  describe 'with france connect token' do
    subject(:make_call) do
      request.headers['Authorization'] = 'Bearer france_connect_token'

      get :show
    end

    let(:params) { default_france_connect_identity_attributes }

    before do
      allow(CNOUS::StudentScholarshipWithFranceConnect).to receive(:call).and_call_original

      mock_cnous_valid_call('france_connect')

      mock_valid_france_connect_checktoken(scopes: minimal_france_connect_scopes.concat(all_scopes))
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

      expect(CNOUS::StudentScholarshipWithFranceConnect).to have_received(:call).with(params:)
    end
  end
end
