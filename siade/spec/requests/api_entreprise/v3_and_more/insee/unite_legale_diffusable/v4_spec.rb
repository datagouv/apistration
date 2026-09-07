require 'swagger_helper'

RSpec.describe 'INSEE: Unites legales diffusibles', api: :entreprise, type: %i[request swagger] do
  path '/v4/insee/sirene/unites_legales/diffusibles/{siren}' do
    get SwaggerData.get('insee.unite_legale_diffusable_v4.title') do
      tags(*SwaggerData.get('insee.unite_legale_diffusable_v4.tags'))

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
        response '200', 'Unite legale trouvee' do
          before do
            stub_insee_authenticate
            stub_insee_unite_legale_active_ge
          end

          let(:siren) { sirens_insee_v3[:active_GE] }

          description SwaggerData.get('insee.unite_legale_diffusable_v4.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('insee.unite_legale_diffusable_v4.attributes'),
            links: SwaggerData.get('insee.unite_legale.links'),
            meta: SwaggerData.get('insee.unite_legale.meta')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siren) { sirens_insee_v3[:active_GE] }

          unprocessable_content_error_request(:siren)

          response '404', 'Non trouvee' do
            before do
              stub_insee_authenticate
              stub_insee_unite_legale_non_diffusable
            end

            let(:siren) { non_diffusable_siren }

            build_rswag_example(NotFoundError.new('INSEE'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('INSEE', INSEE::UniteLegaleDiffusable)
          common_network_error_request('INSEE', INSEE::UniteLegaleDiffusable)

          response '451', 'Indisponible pour des raisons legales' do
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
