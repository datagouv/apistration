RSpec.describe SDH::StatutSportif::BuildResource, type: :build_resource do
  subject(:instance) { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) { read_payload_file('sdh/statut_sportif/found.json') }

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          identite: {
            nom_naissance: 'DUPONT',
            nom_usage: 'DUPONT',
            prenoms: 'Thomas',
            date_naissance: '1990-06-15',
            sexe: 'M'
          },
          est_sportif_de_haut_niveau: true,
          a_ete_sportif_de_haut_niveau: true,
          informations_statut: {
            periode: {
              date_debut_statut: '2025-01-01',
              date_fin_statut: '2025-12-31'
            },
            federation: {
              code_federation: '68',
              nom_federation: 'Fédération Française de Vol Libre',
              nom_court_federation: 'VOL LIBRE'
            },
            etablissement: {
              code_etablissement: '980',
              nom_etablissement: 'MRP OCCITANIE-MONTPELLIER'
            },
            region: {
              code_region: '76',
              nom_region: 'Occitanie'
            },
            categorie: {
              code_categorie: '4',
              nom_categorie: 'Elite',
              valeur: '128'
            },
            sportif_de_haut_niveau: true
          },
          informations_statuts_precedents: [
            {
              fiche: 861_867,
              periode: {
                date_debut_statut: '2024-01-01',
                date_fin_statut: '2024-12-31'
              },
              federation: {
                code_federation: '68',
                nom_federation: 'Fédération Française de Vol Libre',
                nom_court_federation: 'VOL LIBRE'
              },
              etablissement: {
                code_etablissement: '980',
                nom_etablissement: 'MRP OCCITANIE-MONTPELLIER'
              },
              region: {
                code_region: '76',
                nom_region: 'Occitanie'
              },
              categorie: {
                code_categorie: '4',
                nom_categorie: 'Elite',
                valeur: '128'
              },
              sportif_de_haut_niveau: true
            }
          ]
        }
      )
    end
  end
end
