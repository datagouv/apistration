RSpec.describe APIParticulier::V2::MESRI::StudentStatusController do
  let(:all_scopes) { %w[mesri_identifiant mesri_identite mesri_inscription_etudiant mesri_inscription_autre mesri_admission mesri_etablissements] }
  let(:one_field_of_each_scope) { %w[ine nom inscriptions] }

  let(:token) { TokenFactory.new(scopes).valid }
  let(:ine) { '1234567890G' }

  describe 'with ine param' do
    subject { get :show, params: { ine:, token: } }

    describe 'with valid params' do
      before do
        stub_request(:get, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
          status: 200,
          body: Rails.root.join('spec/fixtures/payloads/mesri/student_status/with_ine_valid_response.json').read
        )
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

      context 'when mesri_identite is missing' do
        let(:scopes) { all_scopes - %w[mesri_identite] }

        it 'does not return fields associated to this scope' do
          json = JSON.parse(subject.body)

          (one_field_of_each_scope - %w[nom]).each do |key|
            expect(json).to have_key(key), "#{key} is missing"
          end

          expect(json).not_to have_key('nom')
        end
      end
    end

    describe 'when it is a 404' do
      let(:scopes) { all_scopes }

      before do
        stub_request(:get, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
          status: 404,
          body: Rails.root.join('spec/fixtures/payloads/mesri/student_status/with_ine_not_found_response.json').read
        )
      end

      its(:status) { is_expected.to eq(404) }

      its(:body) do
        is_expected.to eq({
          error: 'not_found',
          reason: 'Student not found',
          message: 'Aucun étudiant n\'a pu être trouvé avec les critères de recherche fournis'
        }.to_json)
      end
    end
  end

  describe 'with civility params' do
    subject { get :show, params: { nom:, prenom:, dateDeNaissance:, lieuDeNaissance:, sexe:, token: } }

    # rubocop:disable RSpec/VariableName
    let(:nom) { 'Dupont' }
    let(:prenom) { 'Jean' }
    let(:dateDeNaissance) { '2000-01-01' }
    let(:lieuDeNaissance) { 'Paris' }
    let(:sexe) { 'm' }
    # rubocop:enable RSpec/VariableName

    describe 'with valid params' do
      before do
        stub_request(:post, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
          status: 200,
          body: Rails.root.join('spec/fixtures/payloads/mesri/student_status/with_civility_valid_response.json').read
        )
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
      request.headers['Authorization'] = 'Bearer token'

      get :show, params:
    end

    let(:params) { {} }

    let(:france_connect_person_identity_attributes) { default_france_connect_identity_attributes }

    before do
      allow(MESRI::StudentStatus::WithCivility).to receive(:call).and_call_original

      stub_request(:post, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
        status: 200,
        body: Rails.root.join('spec/fixtures/payloads/mesri/student_status/with_civility_valid_response.json').read
      )

      mock_valid_france_connect_checktoken(scopes: minimal_france_connect_scopes.concat(all_scopes))
    end

    its(:status) { is_expected.to eq(200) }

    it 'returns all fields' do
      json = JSON.parse(subject.body)

      one_field_of_each_scope.each do |key|
        expect(json).to have_key(key), "#{key} is missing"
      end
    end

    it 'calls MESRI::StudentStatus::WithCivility with france connect person identity attributes, only first first name' do
      make_call

      expect(MESRI::StudentStatus::WithCivility).to have_received(:call).with(
        hash_including(
          params: hash_including(
            token_id: anything,
            family_name: france_connect_person_identity_attributes[:family_name],
            first_name: france_connect_person_identity_attributes[:given_name].split[0],
            birth_date: france_connect_person_identity_attributes[:birthdate],
            birth_place: france_connect_person_identity_attributes[:birthplace],
            gender: 'm'
          )
        )
      )
    end

    context 'when there is an ine param' do
      let(:params) { { ine: 'whatever' } }

      it 'calls MESRI::StudentStatus::WithCivility with france connect person identity attributes, only first first name (ignore INE param)' do
        make_call

        expect(MESRI::StudentStatus::WithCivility).to have_received(:call).with(
          hash_including(
            params: hash_including(
              token_id: anything,
              family_name: france_connect_person_identity_attributes[:family_name],
              first_name: france_connect_person_identity_attributes[:given_name].split[0],
              birth_date: france_connect_person_identity_attributes[:birthdate],
              birth_place: france_connect_person_identity_attributes[:birthplace],
              gender: 'm'
            )
          )
        )
      end
    end
  end
end
