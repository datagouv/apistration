require 'swagger_helper'

RSpec.describe 'RNM: Entreprises artisanales', type: :request do
  path '/v3/rnm/entreprises/{siren}' do
    get 'Récupération des informations d\'une entreprise artisanale' do
      tags 'Informations générales'

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:rnm_cma) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:rnm_cma) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise found', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
          let(:siren) { valid_siren(:rnm_cma) }

          schema type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: {
                    type: :string,
                    example: valid_siren(:rnm_cma),
                  },
                  attributes: {
                    type: :object,
                    properties: {
                      siren: {
                        type: :string,
                        example: valid_siren(:rnm_cma),
                        description: 'Siren de l\'entreprise',
                      },
                      modalite_exercice: {
                        type: :string,
                        example: 'P',
                        description: "Détermine si l'entreprise a une activité permanente ou saisonnière.
                      \n
                      L'activité est dite saisonnière si chaque année, l'entreprise cesse totalement ses activités pendant plus de 3 mois consécutifs.
                      \n
                      \n
                      Les valeurs possibles sont:
                      \n
                      - P => Permanent
                      \n
                      - S => Saisonnière
                      \n
                      - NR => Non renseignée",
                        enum: %w[
                          P
                          S
                          NR
                        ],
                      },
                      non_sedentaire: {
                        type: 'string',
                        example: '0',
                        description: "Indique si l'entreprise a une activité ambulante.
                        \n
                        \n
                        Les valeurs possibles sont:
                        \n
                        - 0 => sédentaire
                        \n
                        - 1 => non-sédentaire",
                        enum: %w[
                          0
                          1
                        ]
                      }
                    },
                    required: %w[
                      siren
                      modalite_exercice
                      non_sedentaire
                    ],
                  },
                  relationships: {
                    type: :object,
                    properties: {
                      adresse: {
                        type: :object,
                        properties: {
                          data: {
                            type: :object,
                            properties: {
                              id: {
                                type: :string,
                                example: "301123626",
                              },
                              type: {
                                type: :string,
                                enum: ['adresse'],
                                example: 'adresse',
                              },
                            }
                          },
                          links: {
                            type: :object,
                            properties: {
                              related: {
                                type: :string,
                                example: "https://entreprises.api.gouv.fr/api/v3/insee/adresse/301123626",
                              }
                            }
                          }
                        }
                      }
                    },
                  }
                },
                required: %w[
                  id
                ],
              },
            },
            required: [
              :data,
            ]

          run_test!
        end

        response '404', 'Entreprise non trouvée', vcr: { cassette_name: 'rnm_cma/not_found_siren' } do
          let(:siren) { not_found_siren(:rnm_cma) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
