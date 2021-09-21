require 'swagger_helper'

RSpec.describe 'MI : Associations', type: %i[request swagger] do
  path '/v3/mi/associations/{siret_or_rna}' do
    get 'Récupération d\'une association' do
      tags 'Informations générales'

      common_action_attributes

      parameter name: :siret_or_rna, in: :path, type: :string

      unauthorized_request do
        let(:siret_or_rna) { valid_rna_id }
      end

      forbidden_request do
        let(:siret_or_rna) { valid_rna_id }
      end

      describe 'with valid mandatory params', valid: true do
        response 200, 'Association found', vcr: { cassette_name: 'mi/associations/with_valid_rna' } do
          schema type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: {
                    type: :string,
                    example: valid_rna_id,
                    description: "Débutant par W et composé de 9 chiffres, il s'agit du numéro RNA, identifiant national de l'association. Ce numéro est attribué automatiquement lors de la déclaration de création d’une association. Une association ne disposant pas d’un numéro RNA s’en voit attribuer un à chaque modification effectuée auprès des services de l’État (modification de statuts ou des dirigeants de l’associations). Le numéro figure alors sur le récépissé délivré par la préfecture.ID RNA ou Siret demandé"
                  },
                  attributes: {
                    type: :object,
                    properties: {
                      titre: {
                        type: :string,
                        example: 'LA PRÉVENTION ROUTIERE'
                      },
                      objet: {
                        type: :string,
                        example: 'Accroitre la sécurité des usagers en encourageant toutes mesures ou initiatives propres à réduire les accidents',
                        description: "Il s'agit d'une description courte mais exhaustive des activités de l'organisme."
                      },
                      siret: {
                        type: :string, nullable: true,
                        example: nil
                      },
                      siret_siege_social: {
                        type: :string,
                        example: '77571979202650'
                      },
                      date_creation: {
                        type: :string,
                        example: '1955-01-01',
                        description: "Il s'agit du jour de dépôt du dossier de création de l'association à la Préfecture."
                      },
                      date_declaration: {
                        type: :string,
                        example: '1955-01-01',
                        description: "Jour de la dernière déclaration faîte par l'association."
                      },
                      date_publication: {
                        type: :string, nullable: true,
                        example: nil,
                        description: "Jour de la publication au journal officiel de l'avis de création de l'association. Toutes les assoiations ne sont pas forcément 'déclarées'. La publication au Journal Officiel permet à l'association de devenir une personne morale, a contrario des 'associations de fait', non déclarées au JO."
                      },
                      date_dissolution: {
                        type: :string, nullable: true,
                        example: nil,
                        description: "Si l'association est dissolue, ce champ indique la date de dissolution, autrement, il est indiqué 'null'."
                      },
                      adresse_siege: {
                        type: :object,
                        properties: {
                          complement: {
                            type: :string,
                            example: '  '
                          },
                          numero_voie: {
                            type: :string,
                            example: '33'
                          },
                          type_voie: {
                            type: :string,
                            example: 'rue'
                          },
                          libelle_voie: {
                            type: :string,
                            example: 'de Modagor'
                          },
                          distribution: {
                            type: :string, nullable: true,
                            example: nil
                          },
                          code_insee: {
                            type: :string,
                            example: '75108'
                          },
                          code_postal: {
                            type: :string,
                            example: '75009'
                          },
                          commune: {
                            type: :string,
                            example: 'Paris'
                          }
                        }
                      },
                      etat: {
                        type: :string,
                        example: 'true'
                      },
                      groupement: {
                        type: :string, nullable: true,
                        example: nil,
                        description: "Trois modalités possibles : si l'association n'est pas un groupement, il est indiqué 'Simple' ; si l'association est un groupement, la valeur est 'Union' ou 'Fédération'. La valeur peut aussi être manquante (nil)."
                      },
                      mise_a_jour: {
                        type: :string,
                        example: '1955-01-01'
                      }
                    }
                  }
                }
              }
            }

          run_test!
        end

        response '404', 'Association not found', vcr: { cassette_name: 'mi/associations/with_rna_not_found' } do
          let(:siret_or_rna) { non_existing_rna_id }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end

        response '422', 'Unprocessable entity', vcr: { cassette_name: 'mi/associations/unprocessable_entity' } do
          let(:siret_or_rna) { 'random_content' }

          schema '$ref' => '#/components/schemas/UnprocessableEntity'

          run_test!
        end
      end
    end
  end
end
