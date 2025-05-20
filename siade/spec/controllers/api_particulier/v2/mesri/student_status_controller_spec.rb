RSpec.describe APIParticulier::V2::MESRI::StudentStatusController do
  let(:all_mesri_scopes) { %w[mesri_identifiant mesri_identite mesri_inscription_etudiant mesri_inscription_autre mesri_admission mesri_etablissements] }
  let(:one_field_of_each_scope) { %w[ine nom inscriptions] }

  let(:token) { TokenFactory.new(scopes).valid }
  let(:ine) { '1234567890G' }

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
        stub_request(:get, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
          status: 200,
          body: read_payload_file('mesri/student_status/with_ine_valid_response.json')
        )
      end

      context 'when token has full access' do
        let(:scopes) { all_mesri_scopes }

        its(:status) { is_expected.to eq(200) }

        it 'returns all fields' do
          json = JSON.parse(subject.body)

          one_field_of_each_scope.each do |key|
            expect(json).to have_key(key), "#{key} is missing"
          end
        end

        it 'returns matching ine params' do
          json = JSON.parse(subject.body)

          expect(json['ine']).to eq(ine)
        end
      end

      context 'when mesri_identite is missing' do
        let(:scopes) { all_mesri_scopes - %w[mesri_identite] }

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
      let(:scopes) { all_mesri_scopes }

      before do
        stub_request(:get, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
          status: 404,
          body: read_payload_file('mesri/student_status/with_ine_not_found_response.json')
        )
      end

      its(:status) { is_expected.to eq(404) }

      its(:body) do
        is_expected.to eq({
          error: 'not_found',
          reason: 'Student not found',
          message: 'Aucun étudiant n\'a pu être trouvé avec les critères de recherche fournis Veuillez vérifier que votre recherche est couverte par le périmètre de l\'API.'
        }.to_json)
      end
    end
  end

  describe 'with civility params' do
    subject { get :show, params: }

    let(:params) do
      {
        nom:,
        prenom:,
        dateDeNaissance:,
        lieuDeNaissance:,
        sexe:,
        token:
      }.compact
    end

    # rubocop:disable RSpec/VariableName
    let(:nom) { 'Dupont' }
    let(:prenom) { 'Jean' }
    let(:dateDeNaissance) { '2000-01-01' }
    let(:lieuDeNaissance) { '99100' }
    let(:sexe) { 'm' }
    # rubocop:enable RSpec/VariableName

    describe 'with valid params' do
      before do
        stub_request(:post, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
          status: 200,
          body: read_payload_file('mesri/student_status/with_civility_valid_response.json')
        )
      end

      context 'when token has full access' do
        let(:scopes) { all_mesri_scopes }

        its(:status) { is_expected.to eq(200) }

        it 'returns all fields' do
          json = JSON.parse(subject.body)

          one_field_of_each_scope.each do |key|
            expect(json).to have_key(key), "#{key} is missing"
          end
        end

        it 'returns null as ine params' do
          json = JSON.parse(subject.body)

          expect(json['ine']).to be_nil
        end
      end
    end

    describe 'with dateDeNaissance missing' do
      let(:scopes) { all_mesri_scopes }

      # rubocop:disable RSpec/VariableName
      let(:dateDeNaissance) { nil }
      # rubocop:enable RSpec/VariableName

      its(:status) { is_expected.to eq(400) }
    end
  end

  describe 'with france connect token' do
    subject(:make_call) do
      request.headers['Authorization'] = 'Bearer token'

      get :show, params:
    end

    let(:recipient) { valid_siret(:recipient) }
    let(:params_from_fc) do
      {
        given_name: 'Jean Martin',
        family_name: 'DUPONT',
        birthdate: '2000-01-01',
        gender: 'male',
        birthplace: '75101',
        birthcountry: '99100'
      }
    end
    let(:params) { params_from_fc.merge(recipient:) }

    before do
      allow(MESRI::StudentStatus::WithCivility).to receive(:call).and_call_original

      stub_request(:post, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
        status: 200,
        body: read_payload_file('mesri/student_status/with_civility_valid_response.json')
      )

      mock_valid_france_connect_checktoken(scopes: minimal_france_connect_scopes.split.concat(all_mesri_scopes).join(' '))
    end

    its(:status) { is_expected.to eq(200) }

    it 'returns all fields' do
      json = JSON.parse(subject.body)

      one_field_of_each_scope.each do |key|
        expect(json).to have_key(key), "#{key} is missing"
      end
    end

    it 'returns null as ine params' do
      json = JSON.parse(subject.body)

      expect(json['ine']).to be_nil
    end

    it 'calls MESRI::StudentStatus::WithCivility with france connect person identity attributes, only first first name' do
      make_call

      expect(MESRI::StudentStatus::WithCivility).to have_received(:call).with(
        hash_including(
          params: hash_including(
            token_id: anything,
            nom_naissance: params[:family_name],
            prenoms: params[:given_name].split,
            annee_date_naissance: params[:birthdate].split('-').first,
            mois_date_naissance: params[:birthdate].split('-').second,
            jour_date_naissance: params[:birthdate].split('-').third,
            code_cog_insee_commune_naissance: params[:birthplace],
            sexe_etat_civil: 'M'
          )
        )
      )
    end

    context 'when there is an ine param' do
      let(:params) { default_france_connect_identity_attributes.merge(recipient:, ine: 'whatever') }

      it 'calls MESRI::StudentStatus::WithCivility with france connect person identity attributes, only first first name (ignore INE param)' do
        make_call

        expect(MESRI::StudentStatus::WithCivility).to have_received(:call).with(
          hash_including(
            params: hash_including(
              token_id: anything,
              nom_naissance: params[:family_name],
              prenoms: params[:given_name].split,
              annee_date_naissance: params[:birthdate].split('-').first,
              mois_date_naissance: params[:birthdate].split('-').second,
              jour_date_naissance: params[:birthdate].split('-').third,
              code_cog_insee_commune_naissance: params[:birthplace],
              sexe_etat_civil: 'M'
            )
          )
        )
      end
    end

    describe 'when recipient is missing' do
      let(:params) { { recipient: nil } }

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
