require 'swagger_helper'

RSpec.describe 'INSEE: Entreprises', type: %i[request swagger] do
  path '/v3/insee/entreprises/{siren}' do
    get 'Récupération des informations d\'une entreprise' do
      tags 'Informations générales'

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'api_insee_fr/siren/active_GE_with_token' } do
          let(:siren) { sirens_insee_v3[:active_GE] }

          schema type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: {
                    type: :string,
                    example: '130025265'
                  },
                  attributes: {
                    type: :object,
                    properties: {
                      siret_siege_social: {
                        type: :string,
                        example: '13002526500013',
                        description: 'Numéro de SIRET du siège social'
                      },
                      type: {
                        type: :string,
                        enum: %w[personne_physique personne_morale],
                        example: 'personne_morale',
                        description: "Détermine si l'entreprise est une personne morale ou une personne physique. Cette valeur est déterminée à l'aide du code juridique : 1000 correspond à une personne physique."
                      },
                      personne_morale_attributs: {
                        type: :object,
                        description: "Attributs associé à la personne morale. L'ensemble des valeurs sont à null pour les personnes physiques.",
                        properties: {
                          raison_sociale: {
                            type: :string,
                            example: 'DINUM',
                            nullable: true,
                            description: 'Raison sociale de l\'entreprise'
                          }
                        },
                        required: %w[raison_sociale]
                      },
                      personne_physique_attributs: {
                        type: :object,
                        description: "Attributs associé à la personne physique. L'ensemble des valeurs sont à null pour les personnes morales.",
                        properties: {
                          pseudonyme: {
                            type: :string,
                            example: 'DJ Falcon',
                            nullable: true,
                            description: "Le pseudonyme correspond au nom qu'une personne utilise pour se désigner dans l'exercice de son activité, généralement littéraire ou artistique."
                          },
                          prenom_usuel: {
                            type: :string,
                            example: 'Jean',
                            nullable: true,
                            description: "Le prénom usuel est le prénom par lequel une personne choisit de se faire appeler dans la vie courante, parmi l'ensemble de ceux qui lui ont été donnés à sa naissance et qui sont inscrits à l'état civil."
                          },
                          prenom_1: {
                            type: :string,
                            example: 'Jean',
                            nullable: true,
                            description: 'Prénom numéro 1 déclaré'
                          },
                          prenom_2: {
                            type: :string,
                            example: 'Jacques',
                            nullable: true,
                            description: 'Prénom numéro 2 déclaré'
                          },
                          prenom_3: {
                            type: :string,
                            example: 'Pierre',
                            nullable: true,
                            description: 'Prénom numéro 3 déclaré'
                          },
                          prenom_4: {
                            type: :string,
                            example: 'Paul',
                            nullable: true,
                            description: 'Prénom numéro 4 déclaré'
                          },
                          nom_usage: {
                            type: :string,
                            example: 'Dupont',
                            nullable: true,
                            description: "Nom que la personne physique a choisi d'utiliser"
                          },
                          nom_naissance: {
                            type: :string,
                            example: 'Dubois',
                            nullable: true,
                            description: "Nom de naissance"
                          },
                          sexe: {
                            type: :string,
                            example: 'M',
                            enum: ['M', 'F', nil],
                            nullable: true,
                            description: 'Caractère féminin ou masculin de la personne physique. Cette valeur peut ne pas être renseignée pour une personne physique.'
                          }
                        },
                        required: %w[
                          pseudonyme
                          prenom_usuel
                          prenom_1
                          prenom_2
                          prenom_3
                          prenom_4
                          nom_usage
                          nom_naissance
                        ]
                      },
                      categorie_entreprise: {
                        type: :string,
                        example: 'GE',
                        enum: [
                          'GE',
                          'ETI',
                          'PME',
                          nil
                        ],
                        description: "Catégorie de l'entreprise. Il s'agit d'une variable statistique calculée par l'INSEE. Elle ne peut prendre que 3 valeurs:
                        \n
                        - GE: Grande Entreprise
                        \n
                        - ETI: Entreprise de Taille Intermédiaire
                        \n
                        - PME: Petite ou Moyenne Entreprise
                        \n
                        Celle-ci peut-être nulle dans certains cas : il s’agit soit d’une unité légale nouvellement créée, soit d’une unité légale cessée, soit d’une unité légale hors champ du calcul de la catégorie (unité légale agricole ou ne faisant pas partie du système productif)
                        \n
                        La définition peut-être trouvée sur le lien suivant : https://www.insee.fr/fr/metadonnees/definition/c1057"
                      },
                      numero_tva_intracommunautaire: {
                        type: :string,
                        example: 'FR07130025265',
                        description: "Numéro de TVA intracommunautaire. Cette valeur est calculée à l'aide du numéro de siren, cette donnée est donc théorique: une entreprise dont le siège social se trouve à l'étranger n'a probablement pas de numéro de TVA français."
                      },
                      diffusable_commercialement: {
                        type: :boolean,
                        example: true,
                        description: "Détermine si l'entreprise est une entreprise non-diffusible. Si celle-ci est non-diffusible, ses informations ne doivent en aucun cas être accessibles au grand public."
                      },
                      forme_juridique: {
                        type: :object,
                        properties: {
                          code: {
                            type: :string,
                            example: '7120',
                            description: "Code de la forme juridique de l'entreprise. Cette variable est à 1000 pour les personnes physiques. La liste complète se trouve ici: https://www.insee.fr/fr/information/2028129"
                          },
                          libelle: {
                            type: :string,
                            example: "Service central d'un ministère",
                            description: "Libellé associé au code de la forme juridique de l'entreprise. Si le code ne correspond à aucun libellé la valeur 'non référencé' est utilisée."
                          }
                        },
                        required: %w[code libelle]
                      },
                      activite_principale: {
                        type: :object,
                        properties: {
                          code: {
                            type: :string,
                            example: '8411Z',
                            description: "Code de l'activité principale (APE) de l'entreprise. Ce code est extrait de la nomenclature NAF. A noter qu'une entreprise n'ayant pas encore de code APE peut se voir affecter la valeur 00.00Z de manière provisoire."
                          },
                          libelle: {
                            type: :string,
                            nullable: true,
                            example: 'Administration publique générale',
                            description: "Libellé associé au code APE. Si le code n'est pas renseigné dans la nomenclature 'Naf Rév2' (nomenclature en vigueur), le libellé n'est pas renseigné ici. Si le code ne correspond à aucun libellé au sein de la nomenclature 'Naf Rév2', la valeur 'non référencé' est utilisée.
                            \n
                            \n
                            Le lien vers la nomenclature 'Naf Rév2' : https://www.insee.fr/fr/information/2406147
                            "
                          },
                          nomenclature: {
                            type: :string,
                            example: 'NAFRev2',
                            description: 'Nomenclature associée au code'
                          }
                        },
                        required: %w[code libelle nomenclature]
                      },
                      tranche_effectif_salarie: {
                        type: :object,
                        properties: {
                          code: {
                            type: :string,
                            nullable: true,
                            example: '51'
                          },
                          intitule: {
                            type: :string,
                            nullable: true,
                            example: '2 000 à 4 999 salariés'
                          },
                          date_reference: {
                            type: :string,
                            nullable: true,
                            example: '2016'
                          },
                          de: {
                            type: :integer,
                            example: 2000,
                            nullable: true
                          },
                          a: {
                            type: :integer,
                            example: 4999,
                            nullable: true
                          }
                        },
                        required: %w[code intitule date_reference de a]
                      },
                      etat_administratif: {
                        type: :string,
                        enum: %w[A C],
                        example: 'A'
                      },
                      date_cessation: {
                        type: :integer,
                        nullable: true,
                        example: 1634133818
                      },
                      date_creation: {
                        type: :integer,
                        example: 1634103818
                      }
                    },
                    required: %w[
                      siret_siege_social
                      categorie_entreprise
                      numero_tva_intracommunautaire
                      diffusable_commercialement
                      type
                      personne_morale_attributs
                      personne_physique_attributs
                      forme_juridique
                      activite_principale
                      tranche_effectif_salarie
                      etat_administratif
                      date_cessation
                      date_creation
                    ]
                  },
                  links: {
                    type: :object,
                    properties: {
                      siege_social: {
                        type: :string,
                        example: 'https://entreprises.api.gouv.fr/api/v3/insee/etablissements/30613890001294',
                        description: 'Lien vers la ressource établissement correspondant au siège social'
                      },
                      siege_social_adresse: {
                        type: :string,
                        example: 'https://entreprises.api.gouv.fr/api/v3/insee/etablissements/30613890001294/adresse',
                        description: "Lien vers la ressource adresse de l'établissement correspondant au siège social"
                      }
                    },
                    required: %w[
                      siege_social
                      siege_social_adresse
                    ]
                  },
                  meta: {
                    type: :object,
                    properties: {
                      date_derniere_mise_a_jour: {
                        type: :integer,
                        example: 1618396818,
                        description: "Date de la dernière mise à jour à l'INSEE"
                      }
                    },
                    required: %w[
                      date_derniere_mise_a_jour
                    ]
                  }
                },
                required: %w[
                  id
                  type
                  attributes
                  links
                  meta
                ]
              }
            },
            required: %w[
              data
            ]

          run_test!
        end

        response '404', 'Non trouvée', vcr: { cassette_name: 'api_insee_fr/siren/non_existent_with_token' } do
          let(:siren) { non_existent_siren }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
