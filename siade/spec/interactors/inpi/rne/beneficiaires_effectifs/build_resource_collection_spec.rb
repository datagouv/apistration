RSpec.describe INPI::RNE::BeneficiairesEffectifs::BuildResourceCollection, type: :build_resource do
  describe '.call' do
    subject(:call) { described_class.call(response:) }

    let(:response) { instance_double(Net::HTTPOK, body:) }
    let(:body) do
      read_payload_file('inpi/rne/valid.json')
    end

    let(:valid_collection) do
      [
        {
          nom: 'DUPONT',
          nom_usage: 'DUBOIS',
          prenoms: %w[JEAN MARC],
          date_naissance: {
            annee: '1989',
            mois: '01'
          },
          modalites: {
            detention_de_capital: {
              parts_totale: 49.0,
              parts_directes: {
                detention: true,
                pleine_propriete: 49.0,
                nue_propriete: 0.0
              },
              parts_indirectes: {
                detention: false,
                par_indivision: {
                  total: 0.0,
                  pleine_propriete: 0.0,
                  nue_propriete: 0.0
                },
                via_personnes_morales: {
                  total: 0.0,
                  pleine_propriete: 0.0,
                  nue_propriete: 0.0
                }
              }
            },
            vocation_a_devenir_titulaire_de_parts: {
              parts_directes: {
                pleine_propriete: 0.0,
                nue_propriete: 0.0
              },
              parts_indirectes: {
                par_indivision: {
                  total: 0.0,
                  pleine_propriete: 0.0,
                  nue_propriete: 0.0
                },
                via_personnes_morales: {
                  total: 0.0,
                  pleine_propriete: 0.0,
                  nue_propriete: 0.0
                }
              }
            },
            droits_de_vote: {
              total: 0.0,
              directes: {
                detention: true,
                pleine_propriete: 49.0,
                nue_propriete: 0.0,
                usufruit: 0.0
              },
              indirectes: {
                detention: false,
                par_indivision: {
                  total: 0.0,
                  pleine_propriete: 0.0,
                  nue_propriete: 0.0,
                  usufruit: 0.0
                },
                via_personnes_morales: {
                  total: 0.0,
                  pleine_propriete: 0.0,
                  nue_propriete: 0.0,
                  usufruit: 0.0
                }
              }
            },
            pouvoirs_de_controle: {
              decision_ag: false,
              nommage_membres_conseil_administratif: false,
              autres: false
            },
            representant_legal: false,
            representant_legal_placement_sans_gestion_deleguee: false
          }
        },
        {
          nom: 'MARTIN',
          nom_usage: nil,
          prenoms: %w[JULES ANDRE],
          date_naissance: {
            annee: '1990',
            mois: '01'
          },
          modalites: {
            detention_de_capital: {
              parts_totale: 51.0,
              parts_directes: {
                detention: true,
                pleine_propriete: 51.0,
                nue_propriete: 0.0
              },
              parts_indirectes: {
                detention: false,
                par_indivision: {
                  total: 0.0,
                  pleine_propriete: 0.0,
                  nue_propriete: 0.0
                },
                via_personnes_morales: {
                  total: 0.0,
                  pleine_propriete: 0.0,
                  nue_propriete: 0.0
                }
              }
            },
            vocation_a_devenir_titulaire_de_parts: {
              parts_directes: {
                pleine_propriete: 0.0,
                nue_propriete: 0.0
              },
              parts_indirectes: {
                par_indivision: {
                  total: 0.0,
                  pleine_propriete: 0.0,
                  nue_propriete: 0.0
                },
                via_personnes_morales: {
                  total: 0.0,
                  pleine_propriete: 0.0,
                  nue_propriete: 0.0
                }
              }
            },
            droits_de_vote: {
              total: 0.0,
              directes: {
                detention: true,
                pleine_propriete: 51.0,
                nue_propriete: 0.0,
                usufruit: 0.0
              },
              indirectes: {
                detention: false,
                par_indivision: {
                  total: 0.0,
                  pleine_propriete: 0.0,
                  nue_propriete: 0.0,
                  usufruit: 0.0
                },
                via_personnes_morales: {
                  total: 0.0,
                  pleine_propriete: 0.0,
                  nue_propriete: 0.0,
                  usufruit: 0.0
                }
              }
            },
            pouvoirs_de_controle: {
              decision_ag: false,
              nommage_membres_conseil_administratif: false,
              autres: false
            },
            representant_legal: false,
            representant_legal_placement_sans_gestion_deleguee: false
          }
        }
      ]
    end

    let(:valid_meta) do
      {
        count: 2
      }
    end

    let(:resource_collection) { call.bundled_data.data }

    it { is_expected.to be_a_success }

    it 'builds valid resources' do
      expect(resource_collection).to all be_a(Resource)
    end

    it 'Have limit amount of resources' do
      expect(resource_collection.count).to eq(2)
    end

    it 'has meta' do
      meta = call.bundled_data.context

      expect(meta).to eq(valid_meta)
    end

    it 'has valid resource_collection' do
      expect(resource_collection.map(&:to_h)).to eq(valid_collection)
    end
  end
end
