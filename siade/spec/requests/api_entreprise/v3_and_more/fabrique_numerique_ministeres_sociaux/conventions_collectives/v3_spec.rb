require 'swagger_helper'

RSpec.describe 'FabriqueNumeriqueMinisteresSociaux: Conventionscollectives', api: :entreprise, type: %i[request swagger] do
  path '/v3/fabrique_numerique_ministeres_sociaux/etablissements/{siret}/conventions_collectives' do
    get SwaggerData.get('fabrique_numerique_ministeres_sociaux.conventions_collectives.title') do
      deprecated true

      tags(*SwaggerData.get('fabrique_numerique_ministeres_sociaux.conventions_collectives.tags'))

      common_action_attributes

      parameter_siret

      unauthorized_request do
        let(:siret) { valid_siret(:conventions_collectives) }
      end

      forbidden_request do
        let(:siret) { valid_siret(:conventions_collectives) }
      end

      too_many_requests(FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives) do
        let(:siret) { valid_siret(:conventions_collectives) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'fabrique_numerique_ministeres_sociaux/conventions_collectives/valid_siret' } do
          description SwaggerData.get('fabrique_numerique_ministeres_sociaux.conventions_collectives.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            properties: SwaggerData.get('fabrique_numerique_ministeres_sociaux.conventions_collectives.attributes'),
            item_meta: SwaggerData.get('fabrique_numerique_ministeres_sociaux.conventions_collectives.meta')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siret) { valid_siret(:conventions_collectives) }

          unprocessable_content_error_request(:siret)

          response '404', 'Non trouvée', vcr: { cassette_name: 'fabrique_numerique_ministeres_sociaux/conventions_collectives/not_found_siret' } do
            let(:siret) { not_found_siret(:conventions_collectives) }

            build_rswag_example(NotFoundError.new('Fabrique numérique des Ministères Sociaux'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('Fabrique numérique des Ministères Sociaux', FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives)
          common_network_error_request('Fabrique numérique des Ministères Sociaux', FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives)
        end
      end
    end
  end
end
