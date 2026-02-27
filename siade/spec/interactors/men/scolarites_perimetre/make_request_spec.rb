RSpec.describe MEN::ScolaritesPerimetre::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:, token:, recipient:, perimetre_type:, perimetre_valeurs:) }

    let(:token) { 'jwt-access-token' }
    let(:recipient) { '13002526500013' }
    let(:perimetre_type) { 'region' }
    let(:perimetre_valeurs) { %w[11] }
    let(:params) do
      {
        nom_naissance: 'NOMFAMILLE',
        prenoms: ['prenom'],
        sexe_etat_civil: 'f',
        jour_date_naissance: '10',
        mois_date_naissance: '06',
        annee_date_naissance: '2000',
        annee_scolaire: '2021',
        degre_etablissement: '2D',
        codes_bcn_regions: %w[11]
      }
    end

    it_behaves_like 'a make request with working mocking_params'

    context 'with valid params' do
      before { stub_men_scolarites_perimetre_valid }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }

      it 'sends a POST request with correct JSON body' do
        subject

        expected_body = {
          nom: 'NOMFAMILLE',
          prenom: 'prenom',
          sexe: 2,
          'date-naissance': '2000-06-10',
          'annee-scolaire': '2021',
          scope: 'men_statut_scolarite',
          'degre-etablissement': '2D',
          'type-perimetre': 'region',
          'valeurs-perimetre': %w[11]
        }

        expect(
          a_request(:post, "#{Siade.credentials[:men_scolarites_url_v2]}/perimetre")
            .with(
              body: expected_body.to_json,
              headers: {
                'Authorization' => 'Bearer jwt-access-token',
                'X-Siret-Partenaire' => '13002526500013',
                'Content-Type' => 'application/json'
              }
            )
        ).to have_been_made.once
      end
    end
  end
end
