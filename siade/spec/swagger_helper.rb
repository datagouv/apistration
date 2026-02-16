Rails.root.glob('spec/support/rswag_*.rb').each { |f| require f }

RSpec.shared_context 'Mandatory params' do
  let(:context) { 'Dev' }
  let(:recipient) { '13002526500013' }
  let(:object) { 'Tests' }
end

# rubocop:disable RSpec/VariableName
RSpec.shared_context 'Valid params (mandatory and token)' do
  include_context 'Mandatory params'

  let(:Authorization) { "Bearer #{yes_jwt}" }
end

RSpec.shared_context 'Valid mandatory params and no token' do
  include_context 'Mandatory params'

  let(:Authorization) { nil }
end

RSpec.shared_context 'Valid mandatory params and unauthorized token' do
  include_context 'Mandatory params'

  let(:Authorization) { "Bearer #{nope_jwt}" }
end
# rubocop:enable RSpec/VariableName

# rubocop:disable Metrics/MethodLength
def build_rswag_error(title: nil, detail: nil, code: nil)
  {
    type: :object,
    properties: {
      errors: {
        type: :array,
        items: {
          type: :object,
          properties: {
            title: {
              type: :string,
              example: title
            }.compact,
            detail: {
              type: :string,
              example: detail
            }.compact,
            code: {
              type: :string,
              example: code
            }.compact
          },
          required: %w[
            title
            detail
            code
          ]
        }
      }
    },
    required: %w[
      errors
    ]
  }
end

def build_rswag_error_particulier_v2(type: nil, reason: nil, message: nil)
  {
    type: :object,
    properties: {
      error: {
        type: :string,
        example: type
      },
      reason: {
        type: :string,
        example: reason
      },
      message: {
        type: :string,
        example: message
      }
    }
  }
end
# rubocop:enable Metrics/MethodLength

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.openapi_specs = {
    'openapi-entreprise.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API Entreprise',
        version: '3.0.0',
        description: "Cette page contient la documentation technique pour accéder à API Entreprise. Les API étant accessible uniquement sous habilitation, l'interaction avec l'environnement de production n'est possible que si vous êtes **en possession d'une clé d'accès (jeton).

### Comment tester l'API ?

Il est possible de tester les API via notre environnement de **staging** qui vous retournera systématiquement des données fictives. Référez vous à la [documentation](https://entreprise.api.gouv.fr/developpeurs#tester-api-preproduction).

Il est nécessaire d'utiliser un jeton de staging. Plus d'infos ici: https://github.com/etalab/siade_staging_data/tree/develop/tokens
      ",
        termsOfService: 'https://entreprise.api.gouv.fr/cgu/',
        contact:
        {
          name: 'Support API Entreprise',
          email: 'support@entreprise.api.gouv.fr',
          url: 'https://entreprise.api.gouv.fr/'
        }
      },
      tags: [
        {
          name: 'Informations générales'
        },
        {
          name: 'Informations financières'
        },
        {
          name: 'Attestations sociales et fiscales'
        },
        {
          name: 'Certifications professionnelles'
        },
        {
          name: 'Propriété intellectuelle'
        }
      ],
      paths: {},
      servers: [
        {
          url: 'https://entreprise.api.gouv.fr',
          description: 'Environnement de production'
        },
        {
          url: 'https://staging.entreprise.api.gouv.fr',
          description: 'Environnement de staging'
        }
      ],
      components: {
        schemas: {
          Error: build_rswag_error
        },
        securitySchemes: {
          jwt_bearer_token: {
            type: :http,
            description: "Votre jeton d'authentification doit être placé dans le header 'Authorization: Bearer VOTRE_JWT', sa validité est de 18 mois.

    Exemple cURL :

        curl -X GET \\
        -H \"Authorization: Bearer $token\" \\
        --url \"https://entreprise.api.gouv.fr/v3/...\"",
            name: 'Authorization',
            in: :header,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        }
      }
    },
    'openapi-particulierv2.yaml' => {
      openapi: '3.0.0',
      info: {
        title: 'API Particulier',
        version: '2.2.0',
        description: "## Bienvenue sur la documentation interactive d'API Particulier.

### Commencer à utiliser l'API

API Particulier est une API en accès restreint, ce qui signifie qu'il vous faut remplir une [demande d'habilitation](https://datapass.api.gouv.fr) avant de pouvoir l'utiliser avec des vraies données.

Afin de tester l'API avant la validation de votre demande d'habilitation, nous avons mis en place un bac à sable de l'API qui reproduit les comportements de l'API en production.

Dans le bac à sable, pour chaque type de donnée disponible, un jeu de donnée libre en édition est mis à votre disposition, afin que vous puissiez faire vos tests en toute autonomie.

Le fonctionnement du bac à sable est identique à celui de la véritable API de production, à la différence près que les données sont fictives, éditables par tout le monde, et que les jetons d'accès sont en libre service.

Le bac à sable et l'API de production sont appelables par deux adresses distinctes :

- bac à sable : [https://staging.particulier.api.gouv.fr](https://staging.particulier.api.gouv.fr)
- production : [https://particulier.api.gouv.fr](https://particulier.api.gouv.fr)

Pour récupérer le jeton de production un portail développeur est mis à votre disposition à l'adresse suivante : [https://particulier.api.gouv.fr/compte](https://particulier.api.gouv.fr/compte)

Pour effectuer vos tests sur le bac à sable, référez-vous à ce dépôt github: [etalab/siade_staging_data](https://github.com/etalab/siade_staging_data/) (l'ancien système basé sur Airtable n'est plus maintenu et va être remplacé par le nouveau système). Un jeton nommé default est disponible ici: [tokens](https://github.com/etalab/siade_staging_data/tree/develop/tokens)

### Accéder à la version 3 de l'API

L'API particulier v3 est actuellement en version beta, vous pouvez accéder à sa documentation [ici](https://particulier.api.gouv.fr/developpeurs/openapi).

### Périmètre des données retournées

**Important :** le contenu du jeu de données retourné dépend des _scopes_ ou _périmètres_ du jeton utilisé.

En effet, les disposition de l'article [L144-8](https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000045213315) n'autorisent que l'échange des informations **strictement nécessaires** pour traiter une démarche.

Afin de respecter ce devoir de minimisation de la donnée, chaque jeton est associé, par la demande d'habilitation, à des _scopes_ agissant comme des masques sur la donnée.

Ainsi, pour pouvoir lire de la donnée, il est nécessaire de cocher lors de votre [demande d'habilitation](https://datapass.api.gouv.fr) une ou plusieurs cases correspondant aux données du même fournisseur, votre jeton possèdera alors les _scopes_ associés aux données cochées.

En conséquence, suivant le jeton utilisé, une même requête peut retourner des résultats différents.

**Attention :** La documentation ci-dessous ne prend pas en compte les _scopes_, qui agissent comme masques de la donnée retournée par l'API. Cette documentation suppose donc que votre jeton permet d'accéder à la donnée décrite.

### Passer son service en production

Lors de votre passage en production :

- remplacez l'URL de staging.particulier.api.gouv.fr à particulier.api.gouv.fr
- remplacez le jeton de test par le jeton obtenu sur [le portail API Particulier](https://particulier.api.gouv.fr/compte)
",
        termsOfService: 'https://api.gouv.fr/resources/CGU%20API%20Particulier.pdf',
        contact: {
          name: 'Contact API Particulier',
          email: 'api-particulier@api.gouv.fr',
          url: 'https://particulier.api.gouv.fr/'
        },
        license: {
          name: 'GNU Affero General Public License v3.0',
          url: 'https://github.com/betagouv/api-particulier/blob/master/LICENSE'
        }
      },
      tags: [],
      paths: {},
      security: [
        { apiKey: [] }
      ],
      servers: [
        {
          url: 'https://particulier.api.gouv.fr',
          description: 'Environnement de production'
        },
        {
          url: 'https://staging.particulier.api.gouv.fr',
          description: 'Environnement de staging'
        }
      ],
      components: {
        schemas: {
          Error: build_rswag_error_particulier_v2
        },
        securitySchemes: {
          apiKey: {
            type: :apiKey,
            name: 'X-Api-Key',
            in: :header,
            description: "Jeton d'authentification obtenu suite à la validation de votre <a href='https://datapass.api.gouv.fr/'>demande d'habilitation</a>, visible sur <a href='https://particulier.api.gouv.fr/compte'>le portail API Particulier</a>. Obligatoire, sauf sur une API FranceConnectée lorsqu'un jeton FranceConnect est présent."
          },
          franceConnectToken: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'Jeton FranceConnect',
            description: "Jeton FranceConnect obtenu suite à une cinématique de connexion FranceConnect. Ne fonctionne que sur les APIs FranceConnectées. Remplace l'authentification par X-Api-Key sur les APIs FranceConnectées."
          }
        }
      }
    },
    'openapi-particulier.yaml' => {
      openapi: '3.0.0',
      info: {
        title: 'API Particulier',
        version: '3.0.0',
        description: "## Bienvenue sur la documentation interactive d'API Particulier.

### Commencer à utiliser l'API

API Particulier est une API en accès restreint, ce qui signifie qu'il vous faut remplir une [demande d'habilitation](https://datapass.api.gouv.fr) avant de pouvoir l'utiliser avec des vraies données.

Afin de tester l'API avant la validation de votre demande d'habilitation, nous avons mis en place un bac à sable de l'API qui reproduit les comportements de l'API en production.

Dans cet environnement, les données sont fictives et éditables par tout le monde. Cet environnement essaye de simuler au mieux les compotements en production en fournissant des réponses à un ensemble de paramètre fixe.
Pour accéder à l'environnement de staging, référez-vous à la [documentation](https://particulier.api.gouv.fr/developpeurs#tester-api-preproduction).

Le bac à sable et l'API de production sont appelables par deux adresses distinctes :

- bac à sable : [https://staging.particulier.api.gouv.fr](https://staging.particulier.api.gouv.fr)
- production : [https://particulier.api.gouv.fr](https://particulier.api.gouv.fr)

Pour récupérer le jeton de production un portail développeur est mis à votre disposition à l'adresse suivante : [https://particulier.api.gouv.fr/compte](https://particulier.api.gouv.fr/compte)

Pour effectuer vos tests sur le bac à sable, référez-vous à ce dépôt github: [etalab/siade_staging_data](https://github.com/etalab/siade_staging_data/) (l'ancien système basé sur Airtable n'est plus maintenu et va être remplacé par le nouveau système). Un jeton nommé default est disponible ici: [tokens](https://github.com/etalab/siade_staging_data/tree/develop/tokens)

### Accéder à la version 2 de l'API

Vous pouvez accéder à la documentation v2 [ici](https://particulier.api.gouv.fr/developpeurs/openapi-v2).

### Périmètre des données retournées

**Important :** le contenu du jeu de données retourné dépend des _scopes_ ou _périmètres_ du jeton utilisé.

En effet, les disposition de l'article [L144-8](https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000045213315) n'autorisent que l'échange des informations **strictement nécessaires** pour traiter une démarche.

Afin de respecter ce devoir de minimisation de la donnée, chaque jeton est associé, par la demande d'habilitation, à des _scopes_ agissant comme des masques sur la donnée.

Ainsi, pour pouvoir lire de la donnée, il est nécessaire de cocher lors de votre [demande d'habilitation](https://datapass.api.gouv.fr) une ou plusieurs cases correspondant aux données du même fournisseur, votre jeton possèdera alors les _scopes_ associés aux données cochées.

En conséquence, suivant le jeton utilisé, une même requête peut retourner des résultats différents.

**Attention :** La documentation ci-dessous ne prend pas en compte les _scopes_, qui agissent comme masques de la donnée retournée par l'API. Cette documentation suppose donc que votre jeton permet d'accéder à la donnée décrite.

### Passer son service en production

Lors de votre passage en production :

- remplacez l'URL de staging.particulier.api.gouv.fr à particulier.api.gouv.fr
- remplacez le jeton de test par le jeton obtenu sur [le portail API Particulier](https://particulier.api.gouv.fr/compte)
",
        termsOfService: 'https://api.gouv.fr/resources/CGU%20API%20Particulier.pdf',
        contact: {
          name: 'Contact API Particulier',
          email: 'api-particulier@api.gouv.fr',
          url: 'https://particulier.api.gouv.fr/'
        },
        license: {
          name: 'GNU Affero General Public License v3.0',
          url: 'https://github.com/betagouv/api-particulier/blob/master/LICENSE'
        }
      },
      tags: [],
      paths: {},
      servers: [
        {
          url: 'https://particulier.api.gouv.fr',
          description: 'Environnement de production'
        },
        {
          url: 'https://staging.particulier.api.gouv.fr',
          description: 'Environnement de staging'
        }
      ],
      components: {
        schemas: {
          Error: build_rswag_error
        },
        securitySchemes: {
          jwt_bearer_token: {
            type: :http,
            description: "Votre jeton d'authentification doit être placé dans le header 'Authorization: Bearer VOTRE_JWT', sa validité est de 18 mois. Dans le cas où vous utilisez une API FranceConnectée, vous devez utiliser le jeton FranceConnect à la place du jeton d'authentification.

    Exemple cURL :

        curl -X GET \\
        -H \"Authorization: Bearer $token\" \\
        --url \"https://particulier.api.gouv.fr/v3/...\"",
            name: 'Authorization',
            in: :header,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml

  config.include_context 'Valid params (mandatory and token)', valid: true
  config.include_context 'Valid mandatory params and no token', authenticate: false

  config.after(:each, type: :swagger) do
    Rack::Attack.reset!
  end

  config.extend RSwagCommonResponses
  config.extend RSwagCommonErrors
  config.extend RSwagResourcesPayloads
  config.extend RSwagParametersAPIEntreprise
  config.extend RSwagParametersAPIParticulier
end
