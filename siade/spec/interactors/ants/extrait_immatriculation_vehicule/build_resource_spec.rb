RSpec.describe ANTS::ExtraitImmatriculationVehicule::BuildResource, type: :build_resource do
  subject(:instance) { described_class.call(response:, params:, matched_identity:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) { read_payload_file('ants/found_siv.xml') }
  let(:params) do
    {
      nom_naissance: 'DUPONT',
      prenoms: ['JEAN'],
      sexe_etat_civil: 'M',
      annee_date_naissance: 1955,
      mois_date_naissance: 12,
      jour_date_naissance: 8,
      code_cog_insee_commune_naissance: '59350'
    }
  end

  let(:matched_identity) do
    {
      libelle_type_personne: 'titulaire',
      identite_from_ants: {
        nom_naissance: 'DUPONT',
        prenoms: ['JEAN'],
        sexe_etat_civil: 'M',
        annee_date_naissance: 2000,
        mois_date_naissance: 1,
        jour_date_naissance: 1,
        code_departement_naissance: '75'
      },
      address_from_ants: {
        complement_information: nil,
        num_voie: '12',
        type_voie: 'AVENUE',
        libelle_voie: 'DES CHAMPS',
        code_postal_ville: '59000',
        libelle_commune: 'LILLE',
        lieu_dit: nil,
        etage_escalier_appartement: nil,
        extension: nil,
        pays: 'FRANCE'
      }
    }
  end

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          identite_particulier: {
            nom: 'DUPONT',
            prenom: 'JEAN',
            sexe_etat_civil: 'M',
            annee_date_naissance: 2000,
            mois_date_naissance: 1,
            jour_date_naissance: 1,
            code_departement_naissance: '75'
          },
          adresse_particulier: {
            complement_information: nil,
            num_voie: '12',
            type_voie: 'AVENUE',
            libelle_voie: 'DES CHAMPS',
            code_postal_ville: '59000',
            libelle_commune: 'LILLE',
            lieu_dit: nil,
            etage_escalier_appartement: nil,
            extension: nil,
            pays: 'FRANCE'
          },
          statut_rattachement: 'titulaire',
          donnees_immatriculation_vehicule: {
            numero_immatriculation: 'TT-939-WA',
            date_premiere_immatriculation: '2009-02-18',
            statut_location: {
              code: 'N',
              label: 'Normale'
            }
          },
          caracteristiques_techniques_vehicule: {
            marque: 'PEUGEOT',
            type_variante_version: '4H5FTF',
            denomination_commerciale: '308',
            masse_charge_maximale: 2145,
            categorie_vehicule: {
              code: 'M1',
              label: 'Véhicule de transport de personnes comportant au maximum 8 places assises outre le siège du conducteur'
            },
            genre_national: {
              code: 'VP',
              label: 'Voiture Particulière'
            },
            cylindree: 1598,
            type_carburant: {
              code: 'ES',
              label: 'Essence'
            },
            taux_co2: 194,
            classe_environnementale: {
              code: 'Euro 4',
              label: 'Norme européenne d\'émission Euro 4'
            }
          }
        }
      )
    end

    describe 'when raw_code is nil' do
      let(:body) { read_payload_file('ants/found_siv_no_raw_code.xml') }

      it 'doesnt error' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
