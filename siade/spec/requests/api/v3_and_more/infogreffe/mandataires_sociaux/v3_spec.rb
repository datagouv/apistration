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
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: {
                      type: :string,
                      example: "#{valid_siren(:extrait_rcs)}-0",
                      description: "Siren demandé suivi d'un tiret et du placement du mandataire social dans la collection (en partant de zéro). Example: il y a 12 mandataires sociaux, la première ID sera #{valid_siren(:extrait_rcs)}-0 et la dernière #{valid_siren(:extrait_rcs)}-11"
                    },
                    attributes: {
                      type: :object,
                      description: 'Il y a deux types de mandataires sociaux, les personnes physiques et les personnes morales.',
                      properties: {
                        nom: {
                          type: :string, nullable: true,
                          example: 'Henri',
                          description: 'Ne concerne que les personnes physiques'
                        },
                        prenom: {
                          type: :string, nullable: true,
                          example: 'Martin',
                          description: 'Ne concerne que les personnes physiques'
                        },
                        fonction: {
                          type: :string,
                          example: 'COMMISSAIRE AUX COMPTES SUPPLEANT'
                        },
                        date_naissance: {
                          type: :string, nullable: true,
                          example: '1965-01-27',
                          description: 'Ne concerne que les personnes physiques'
                        },
                        date_naissance_timestamp: {
                          type: :number, nullable: true,
                          example: -155_523_600,
                          description: 'Ne concerne que les personnes physiques'
                        },
                        raison_sociale: {
                          type: :string, nullable: true,
                          example: 'BCRH & ASSOCIES - SOCIETE A RESPONSABILITE LIMITEE A ASSOCIE UNIQUE',
                          description: 'Ne concerne que les personnes morales.'
                        },
                        identifiant: {
                          type: :string, nullable: true,
                          example: '490092574',
                          description: 'Ne concerne que les personnes morales. Cet element est facultatif, composé de 7 à 9 chiffres, et peut être vide.'
                        },
                        type: {
                          type: :string,
                          example: 'PP',
                          description: "Signifie qu'il s'agit d'une personne physique (PP) ou morale (PM)"
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
