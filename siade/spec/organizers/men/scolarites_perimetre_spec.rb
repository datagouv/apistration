RSpec.describe MEN::ScolaritesPerimetre, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        nom_naissance: 'NOMFAMILLE',
        prenoms: ['prenom'],
        sexe_etat_civil: 'f',
        annee_date_naissance: '2000',
        mois_date_naissance: '06',
        jour_date_naissance: '10',
        annee_scolaire: '2021',
        degre_etablissement: '2D',
        codes_bcn_departements: nil,
        codes_bcn_regions: %w[11],
        provider_api_version: 'v2'
      }
    end

    before do
      stub_men_scolarites_auth
      stub_men_scolarites_perimetre_valid
    end

    describe 'happy path' do
      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
