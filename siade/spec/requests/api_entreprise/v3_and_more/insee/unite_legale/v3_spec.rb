require 'swagger_helper'

RSpec.describe 'INSEE: Unités légales', api: :entreprise, type: %i[request swagger] do
  path '/v3/insee/sirene/unites_legales/{siren}' do
    get SwaggerData.get('insee.unite_legale.title') do
      tags(*SwaggerData.get('insee.unite_legale.tags'))

      parameter_siren

      common_action_attributes

      unauthorized_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      too_many_requests(INSEE::UniteLegale) do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Unité légale trouvée', vcr: { cassette_name: 'insee/siren/active_GE_with_token' } do
          description SwaggerData.get('insee.unite_legale.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('insee.unite_legale.attributes'),
            links: SwaggerData.get('insee.unite_legale.links'),
            meta: SwaggerData.get('insee.unite_legale.meta')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siren) { sirens_insee_v3[:active_GE] }

          unprocessable_content_error_request(:siren)

          response '404', 'Non trouvée', vcr: { cassette_name: 'insee/siren/non_existent_with_token' } do
            let(:siren) { non_existent_siren }

            build_rswag_example(NotFoundError.new('INSEE'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('INSEE', INSEE::UniteLegale)
          common_network_error_request('INSEE', INSEE::UniteLegale)

          response '451', 'Indisponible pour des raisons légales' do
            let(:siren) { sirens_insee_v3[:active_GE] }

            stubbed_organizer_error(
              INSEE::UniteLegale,
              UnavailableForLegalReasonsError.new('INSEE', 'whatever')
            )

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end
      end
    end
  end
end
