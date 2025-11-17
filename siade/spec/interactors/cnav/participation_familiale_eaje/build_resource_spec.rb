require 'rails_helper'

RSpec.describe CNAV::ParticipationFamilialeEAJE::BuildResource, type: :build_resource do
  subject(:instance) { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) { read_payload_file('cnav/participation_familiale_eaje/make_request_valid.json') }

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it 'builds resource with all attributes' do
      expect(subject).to eq(
        {
          allocataires: [
            {
              nom_naissance: 'DUPOND',
              nom_usage: 'DUPOND',
              prenoms: 'Jean-Michel',
              date_naissance: '1981-06-30',
              sexe: 'M',
              code_cog_insee_commune_naissance: '75113'
            }
          ],
          enfants: [
            {
              nom_naissance: 'DUPOND',
              nom_usage: 'DUPOND',
              prenoms: 'Marie',
              date_naissance: '2020-03-15',
              sexe: 'F',
              code_cog_insee_commune_naissance: '75113'
            }
          ],
          adresse: {
            destinataire: 'M. DUPOND Jean-Michel',
            complement_information: 'Appt 55',
            complement_information_geographique: 'Bat Les Alizes',
            numero_libelle_voie: '32 ter rue du Pont du Roy',
            lieu_dit: 'Au trou salé',
            code_postal_ville: '02100 Bohain en Vermandois',
            pays: 'France'
          },
          parametres_calcul_participation_familiale: {
            nombre_enfants_beneficiaire_aeeh: 0,
            nombre_enfants_a_charge: 1,
            base_ressources_annuelles: {
              valeur: 1500,
              annee_calcul: 2024
            },
            annee: 2024
          }
        }
      )
    end
  end
end
