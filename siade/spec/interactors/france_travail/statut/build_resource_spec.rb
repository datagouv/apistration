RSpec.describe FranceTravail::Statut::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(params: { identifiant: }, response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:identifiant) { 'whatever' }
  let(:body) { read_payload_file('france_travail/statut/valid.json') }

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          identifiant:,
          identite: {
            civilite: 'M.',
            nom_naissance: 'DUPONT',
            nom_usage: nil,
            prenom: 'JEAN',
            sexe: 'Masculin',
            date_naissance: '1990-01-01'
          },
          contact: {
            email: 'jean.dupont@france.fr',
            telephone: '0636656565',
            telephone2: nil
          },
          inscription: {
            date_debut: '2020-01-01',
            date_fin: nil,
            categorie: {
              code: 1,
              libelle: 'PERSONNE SANS EMPLOI DISPONIBLE DUREE INDETERMINEE PLEIN TPS'
            },
            code_certification_cnav: 'VC'
          },
          adresse: {
            code_postal: '75007',
            code_cog_insee_commune: '75107',
            localite: '75001 PARIS',
            ligne_voie: '42 RUE DE LA PAIX',
            ligne_complement_adresse: nil,
            ligne_complement_destinataire: 'APPARTEMENT 42',
            ligne_complement_distribution: nil,
            ligne_nom: 'DUPONT'
          }
        }
      )
    end
  end
end
