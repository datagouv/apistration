require 'swagger_helper'

RSpec.describe 'Infogreffe: Mandataires sociaux', type: %i[request swagger] do
  path '/v3/infogreffe/mandataires_sociaux/{siren}' do
    get "Récupération des mandataires sociaux d'une entreprise" do
      tags 'Informations générales'

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:extrait_rcs) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:extrait_rcs) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise found', vcr: { cassette_name: 'infogreffe/mandataires_sociaux/with_valid_siren' } do
          let(:siren) { valid_siren(:extrait_rcs) }

          schema type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: {
                    type: :string,
                    example: valid_siren(:extrait_rcs)
                  },
                  pp: {
                    type: :array,
                    description: 'Personnes physiques',
                    items: {
                      type: :object,
                      properties: {
                        nom: {
                          type: :string, nullable: true,
                          example: 'Henri'
                        },
                        prenom: {
                          type: :string, nullable: true,
                          example: 'Martin'
                        },
                        fonction: {
                          type: :string,
                          example: 'COMMISSAIRE AUX COMPTES SUPPLEANT'
                        },
                        date_naissance: {
                          type: :string, nullable: true,
                          example: '1965-01-27'
                        },
                        date_naissance_timestamp: {
                          type: :number, nullable: true,
                          example: -155_523_600
                        }
                      }
                    }
                  },
                  pm: {
                    type: :array,
                    description: 'Personnes morales',
                    items: {
                      type: :object,
                      properties: {
                        fonction: {
                          type: :string,
                          example: 'COMMISSAIRE AUX COMPTES SUPPLEANT'
                        },
                        raison_sociale: {
                          type: :string, nullable: true,
                          example: 'BCRH & ASSOCIES - SOCIETE A RESPONSABILITE LIMITEE A ASSOCIE UNIQUE'
                        },
                        identifiant: {
                          type: :string, nullable: true,
                          example: '490092574',
                          description: 'Cet element est facultatif, composé de 7 à 9 chiffres, et peut être vide.'
                        }
                      }
                    }
                  }
                }
              }
            },
            required: [
              :data
            ]

          run_test!
        end

        response '404', 'Entreprise non trouvée',
          vcr: { cassette_name: 'infogreffe/mandataires_sociaux/with_siren_not_found' } do
          let(:siren) { not_found_siren(:extrait_rcs) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end

        response '422', 'Unprocessable entity', vcr: { cassette_name: 'mi/associations/unprocessable_entity' } do
          let(:siren) { 'random_content' }

          schema '$ref' => '#/components/schemas/UnprocessableEntity'

          run_test!
        end
      end
    end
  end
end
