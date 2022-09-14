RSpec.describe APIParticulier::V2::PoleEmploi::StatutController, type: :controller do
  subject { get :show, params: { identifiant:, token: } }

  let(:all_scopes) { %i[pole_emploi_identite pole_emploi_adresse pole_emploi_contact pole_emploi_inscription] }
  let(:one_field_of_each_scope) { %w[civilite adresse email dateInscription] }

  let(:token) { TokenFactory.new(scopes).valid }
  let(:identifiant) { 'whatever' }

  describe 'with valid params', vcr: { cassette_name: 'pole_emploi/oauth2' } do
    before do
      stub_request(:post, Siade.credentials[:pole_emploi_status_url]).and_return(
        status: 200,
        body: Rails.root.join('spec/fixtures/payloads/pole_emploi_statut_valid_payload.json').read
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

    context 'when pole_emploi_identite is missing' do
      let(:scopes) { all_scopes - %i[pole_emploi_identite] }

      it 'does not return this field' do
        json = JSON.parse(subject.body)

        (one_field_of_each_scope - ['civilite']).each do |key|
          expect(json).to have_key(key), "#{key} is missing"
        end

        expect(json).not_to have_key('civilite')
      end
    end
  end

  describe 'when it is a 404', vcr: { cassette_name: 'pole_emploi/oauth2' } do
    let(:scopes) { all_scopes }

    before do
      stub_request(:post, Siade.credentials[:pole_emploi_status_url]).and_return(
        status: 404,
        body: Rails.root.join('spec/fixtures/payloads/pole_emploi_statut_not_found_payload.json').read
      )
    end

    its(:status) { is_expected.to eq(404) }

    its(:body) do
      is_expected.to eq({
        error: 'not_found',
        reason: 'Situation not found',
        message: 'Aucune situation Pôle Emploi n\'a pu être trouvée avec les critères de recherche fournis'
      }.to_json)
    end
  end
end
