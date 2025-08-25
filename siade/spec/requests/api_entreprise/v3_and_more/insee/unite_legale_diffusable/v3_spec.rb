require 'swagger_helper'

RSpec.describe 'INSEE: Unités légales diffusibles', api: :entreprise, type: %i[request swagger] do
  path '/v3/insee/sirene/unites_legales/diffusibles/{siren}' do
    get SwaggerData.get('insee.unite_legale_diffusable.title') do
      tags(*SwaggerData.get('insee.unite_legale_diffusable.tags'))

      parameter_siren

      common_action_attributes

      unauthorized_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      too_many_requests(INSEE::UniteLegaleDiffusable) do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Unité légale trouvée', vcr: { cassette_name: 'insee/siren/active_GE_with_token' } do
          let(:siren) { sirens_insee_v3[:active_GE] }

          description SwaggerData.get('insee.unite_legale_diffusable.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('insee.unite_legale_diffusable.attributes'),
            links: SwaggerData.get('insee.unite_legale.links'),
            meta: SwaggerData.get('insee.unite_legale.meta')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siren) { sirens_insee_v3[:active_GE] }

          unprocessable_content_error_request(:siren)

          response '404', 'Non trouvée', vcr: { cassette_name: 'insee/siren/non_diffusable_with_token' } do
            let(:siren) { non_diffusable_siren }

            build_rswag_example(NotFoundError.new('INSEE'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('INSEE', INSEE::UniteLegaleDiffusable)
          common_network_error_request('INSEE', INSEE::UniteLegaleDiffusable)

          response '451', 'Indisponible pour des raisons légales' do
            let(:siren) { sirens_insee_v3[:active_GE] }

            stubbed_organizer_error(
              INSEE::UniteLegaleDiffusable,
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
