Dir[Rails.root.join('spec/support/rswag_*.rb')].each { |f| require f }

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
def build_rswag_error_entreprise(title: nil, detail: nil, code: nil)
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
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'openapi-entreprise.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API Entreprise',
        version: '3.0.0',
        description: "Cette page contient la documentation technique pour accéder à API Entreprise. Les API étant accessible uniquement sous habilitation, l'interaction avec l'environnement de production n'est possible que si vous êtes **en possession d'une clé d'accès (jeton).

### Comment tester l'API ?

Il est possible de tester les API via notre environnement de **staging** qui vous retournera systématiquement des données fictives. Référez vous à la [documentation](https://entreprise.api.gouv.fr/developpeurs#tester-api-preproduction).

Il est nécessaire d'utiliser le jeton de staging indiqué ci-dessous.

---

*eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDAiLCJqdGkiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDAiLCJzY29wZXMiOlsidXB0aW1lIiwiYXNzb2NpYXRpb25zIiwib3Blbl9kYXRhIiwiYXR0ZXN0YXRpb25zX2FnZWZpcGgiLCJwcm9idHAiLCJjb3Rpc2F0aW9uc19wcm9idHAiLCJhdHRlc3RhdGlvbnNfZmlzY2FsZXMiLCJhdHRlc3RhdGlvbl9maXNjYWxlX2RnZmlwIiwiYXR0ZXN0YXRpb25zX3NvY2lhbGVzIiwiYXR0ZXN0YXRpb25fc29jaWFsZV91cnNzYWYiLCJiaWxhbnNfZW50cmVwcmlzZV9iZGYiLCJiaWxhbnNfYmRmIiwiZm50cF9jYXJ0ZV9wcm8iLCJjZXJ0aWZpY2F0X2NuZXRwIiwiY2VydGlmaWNhdGlvbl9jbmV0cCIsImNlcnRpZmljYXRfb3BxaWJpIiwicXVhbGliYXQiLCJjZXJ0aWZpY2F0X3JnZV9hZGVtZSIsImRvY3VtZW50c19hc3NvY2lhdGlvbiIsImVudHJlcHJpc2VzIiwidW5pdGVzX2xlZ2FsZXNfZXRhYmxpc3NlbWVudHNfaW5zZWUiLCJldGFibGlzc2VtZW50cyIsImV4ZXJjaWNlcyIsImNoaWZmcmVfYWZmYWlyZXNfZGdmaXAiLCJleHRyYWl0c19yY3MiLCJsaWFzc2VfZmlzY2FsZSIsImxpYXNzZXNfZmlzY2FsZXNfZGdmaXAiLCJjZXJ0aWZpY2F0aW9uc19xdWFsaW9waV9mcmFuY2VfY29tcGV0ZW5jZXMiLCJlb3JpX2RvdWFuZXMiLCJjb252ZW50aW9uc19jb2xsZWN0aXZlcyIsIm1hbmRhdGFpcmVzX3NvY2lhdXhfaW5mb2dyZWZmZSIsImFjdGVzX2lucGkiLCJleHRyYWl0X2NvdXJ0X2lucGkiLCJhc3NvY2lhdGlvbnNfZG9ubmVlc19wcm90ZWdlZXMiLCJhc3NvY2lhdGlvbnNfZGplcHZhIiwibXNhX2NvdGlzYXRpb25zIiwiY290aXNhdGlvbnNfbXNhIiwiY2VydGlmaWNhdGlvbl9vcHFpYmkiLCJlbnRyZXByaXNlc19hcnRpc2FuYWxlcyIsImVmZmVjdGlmc191cnNzYWYiLCJjbmFmX3F1b3RpZW50X2ZhbWlsaWFsIiwiY25hZl9hbGxvY2F0YWlyZXMiLCJjbmFmX2VuZmFudHMiLCJjbmFmX2FkcmVzc2UiLCJjb21wbGVtZW50YWlyZV9zYW50ZV9zb2xpZGFpcmUiLCJjbm91c19zdGF0dXRfYm91cnNpZXIiLCJjbm91c19lY2hlbG9uX2JvdXJzZSIsImNub3VzX2VtYWlsIiwiY25vdXNfcGVyaW9kZV92ZXJzZW1lbnQiLCJjbm91c19zdGF0dXRfYm91cnNlIiwiY25vdXNfdmlsbGVfZXR1ZGVzIiwiY25vdXNfaWRlbnRpdGUiLCJkZ2ZpcF9kZWNsYXJhbnQxX25vbSIsImRnZmlwX2RlY2xhcmFudDFfbm9tX25haXNzYW5jZSIsImRnZmlwX2RlY2xhcmFudDFfcHJlbm9tcyIsImRnZmlwX2RlY2xhcmFudDFfZGF0ZV9uYWlzc2FuY2UiLCJkZ2ZpcF9kZWNsYXJhbnQyX25vbSIsImRnZmlwX2RlY2xhcmFudDJfbm9tX25haXNzYW5jZSIsImRnZmlwX2RlY2xhcmFudDJfcHJlbm9tcyIsImRnZmlwX2RlY2xhcmFudDJfZGF0ZV9uYWlzc2FuY2UiLCJkZ2ZpcF9kYXRlX3JlY291dnJlbWVudCIsImRnZmlwX2RhdGVfZXRhYmxpc3NlbWVudCIsImRnZmlwX2FkcmVzc2VfZmlzY2FsZV90YXhhdGlvbiIsImRnZmlwX2FkcmVzc2VfZmlzY2FsZV9hbm5lZSIsImRnZmlwX25vbWJyZV9wYXJ0cyIsImRnZmlwX25vbWJyZV9wZXJzb25uZXNfYV9jaGFyZ2UiLCJkZ2ZpcF9zaXR1YXRpb25fZmFtaWxpYWxlIiwiZGdmaXBfcmV2ZW51X2JydXRfZ2xvYmFsIiwiZGdmaXBfcmV2ZW51X2ltcG9zYWJsZSIsImRnZmlwX2ltcG90X3JldmVudV9uZXRfYXZhbnRfY29ycmVjdGlvbnMiLCJkZ2ZpcF9tb250YW50X2ltcG90IiwiZGdmaXBfcmV2ZW51X2Zpc2NhbF9yZWZlcmVuY2UiLCJkZ2ZpcF9hbm5lZV9pbXBvdCIsImRnZmlwX2FubmVlX3JldmVudXMiLCJkZ2ZpcF9lcnJldXJfY29ycmVjdGlmIiwiZGdmaXBfc2l0dWF0aW9uX3BhcnRpZWxsZSIsIm1lc3JpX2lkZW50aWZpYW50IiwibWVzcmlfaWRlbnRpdGUiLCJtZXNyaV9pbnNjcmlwdGlvbl9ldHVkaWFudCIsIm1lc3JpX2luc2NyaXB0aW9uX2F1dHJlIiwibWVzcmlfYWRtaXNzaW9uIiwibWVzcmlfZXRhYmxpc3NlbWVudHMiLCJwb2xlX2VtcGxvaV9pZGVudGl0ZSIsInBvbGVfZW1wbG9pX2FkcmVzc2UiLCJwb2xlX2VtcGxvaV9jb250YWN0IiwicG9sZV9lbXBsb2lfaW5zY3JpcHRpb24iLCJwb2xlX2VtcGxvaV9wYWllbWVudHMiLCJtZW5fc3RhdHV0X3Njb2xhcml0ZSIsIm1lbl9zdGF0dXRfYm91cnNpZXIiLCJtZW5fZWNoZWxvbl9ib3Vyc2UiXSwic3ViIjoic3RhZ2luZyBkZXZlbG9wbWVudCIsImlhdCI6MTY5MzkwNTAyNCwidmVyc2lvbiI6IjEuMCIsImV4cCI6MjAwOTUyNDIyNH0.uKkMeXNmzwaultKAuS6l1o9StrZky-mY7XLTzygdut4*
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
          Error: build_rswag_error_entreprise
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
    'openapi-particulier.yaml' => {
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

- bac à sable : [https://staging.particulier.api.gouv.fr/api](https://staging.particulier.api.gouv.fr/api)
- production : [https://particulier.api.gouv.fr/api](https://particulier.api.gouv.fr/api)

Pour récupérer le jeton de production un portail développeur est mis à votre disposition à l'adresse suivante : [https://particulier.api.gouv.fr/compte](https://particulier.api.gouv.fr/compte)

Pour effectuer vos tests sur le bac à sable, référez-vous à ce dépôt github: [etalab/siade_staging_data](https://github.com/etalab/siade_staging_data/) (l'ancien système basé sur Airtable n'est plus maintenu et va être remplacé par le nouveau système). Un jeton nommé default est disponible ici: [tokens](https://github.com/etalab/siade_staging_data/tree/develop/tokens)

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
        apiKey: []
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
            description: "Jeton d'authentification obtenu suite à la validation de votre <a href='https://datapass.api.gouv.fr/'>demande d'habilitation</a>, visible sur <a href='https://particulier.api.gouv.fr/compte'>le portail API Particulier</a>"
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml

  config.include_context 'Valid params (mandatory and token)', valid: true
  config.include_context 'Valid mandatory params and no token', authenticate: false

  config.after(:each, type: :swagger) do
    Rack::Attack.reset!
  end

  config.extend RSWagCommonsResponses
  config.extend RSWagResourcesPayloads
end
