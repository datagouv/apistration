RSpec.describe DGFIP::LiensCapitalistiques::BuildResource, type: :build_resource do
  subject(:builder) { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:resource) { builder.bundled_data.data }

  context 'with all cerfas' do
    let(:body) do
      read_payload_file('dgfip/liasses_fiscales/liens_capitalistiques.json')
    end

    it { is_expected.to be_a_success }

    it do
      expect(resource.to_h).to eq(
        {
          capital: {
            actionnaires: [
              {
                type: 'personne_morale',
                pourcentage: 51.0,
                nombre_parts: 510,
                attributs: {
                  siren: '110001013',
                  denomination: 'GOUVERNEMENT PREMIER MINISTRE',
                  complement_denomination: nil,
                  forme_juridique: 'NS'
                },
                adresse: {
                  numero: '0057',
                  voie: 'RUE DE VARENNE',
                  lieu_dit_hameau: nil,
                  code_postal: '75007',
                  ville: 'PARIS',
                  pays: 'FRANCE'
                }
              },
              {
                type: 'personne_physique',
                pourcentage: 24.0,
                nombre_parts: 240,
                attributs: {
                  civilite: 'M',
                  nom_patronymique_et_prenoms: 'CHIRAC Jacques',
                  nom_marital: 'NS',
                  date_naissance: {
                    annee: '1932',
                    mois: '11',
                    jour: '29'
                  },
                  ville_naissance: 'PARIS',
                  departement_naissance: '75005',
                  pays_naissance: 'FRANCE'
                },
                adresse: {
                  numero: '0055',
                  voie: 'RUE DU FAUBOURG-SAINT-HONORE',
                  lieu_dit_hameau: nil,
                  code_postal: '75008',
                  ville: 'PARIS',
                  pays: 'FRANCE'
                }
              },
              {
                type: 'personne_physique',
                pourcentage: 25.0,
                nombre_parts: 250,
                attributs: {
                  civilite: 'M',
                  nom_patronymique_et_prenoms: 'MITTERRAND Francois',
                  nom_marital: 'NS',
                  date_naissance: {
                    annee: '1916',
                    mois: '10',
                    jour: '26'
                  },
                  ville_naissance: 'JARNAC',
                  departement_naissance: '16200',
                  pays_naissance: 'FRANCE'
                },
                adresse: {
                  numero: '0126',
                  voie: 'RUE DE L\'UNIVERSITE',
                  lieu_dit_hameau: nil,
                  code_postal: '75007',
                  ville: 'PARIS',
                  pays: nil
                }
              }
            ],
            repartition: {
              personnes_physiques: {
                total_actions: 490,
                nombre: 2
              },
              personnes_morales: {
                total_actions: 510,
                nombre: 1
              }
            },
            depose_neant: false
          },
          participations: {
            filiales: [
              {
                siren: '130007669',
                denomination: 'ANSII',
                complement_denomination: nil,
                forme_juridique: 'SA',
                pourcentage_detention: 42.0,
                adresse: {
                  numero: '0051 BOULEVARD DE LA TOUR-MAUBOURG',
                  voie: nil,
                  lieu_dit_hameau: nil,
                  code_postal: '75007',
                  ville: 'PARIS',
                  pays: nil
                }
              }
            ],
            nombre_filiales: 1,
            depose_neant: false
          }
        }
      )
    end
  end

  context 'when one cerfa is missing' do
    let(:body) do
      data = JSON.parse(read_payload_file('dgfip/liasses_fiscales/liens_capitalistiques.json'))

      data['declarations'].delete_if { |declaration| declaration['numero_imprime'] == %w[2059F 2059G].sample }

      data.to_json
    end

    it { is_expected.to be_a_success }
  end
end
