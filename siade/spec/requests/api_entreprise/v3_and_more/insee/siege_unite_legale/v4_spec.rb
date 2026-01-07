require 'swagger_helper'

RSpec.describe 'INSEE: Siege Unite Legale', api: :entreprise, type: %i[request swagger] do
  path '/v4/insee/sirene/unites_legales/{siren}/siege_social' do
    get SwaggerData.get('insee.siege_unite_legale_v4.title') do
      tags(*SwaggerData.get('insee.siege_unite_legale_v4.tags'))

      tags 'Informations generales'

      parameter_siren

      common_action_attributes

      unauthorized_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siren) { sirens_insee_v3[:active_GE] }
      end

      too_many_requests(INSEE::SiegeUniteLegale) do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Etablissement trouve', vcr: { cassette_name: 'insee/siege/active_GE_with_token' } do
          description SwaggerData.get('insee.siege_unite_legale_v4.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('insee.etablissement_v4.attributes'),
            links: SwaggerData.get('insee.etablissement.links'),
            meta: SwaggerData.get('insee.etablissement.meta')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siren) { sirens_insee_v3[:active_GE] }

          unprocessable_content_error_request(:siren)

          response '404', 'Non trouve', vcr: { cassette_name: 'insee/siege/non_existent_with_token' } do
            let(:siren) { non_existent_siren }

            build_rswag_example(NotFoundError.new('INSEE'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('INSEE', INSEE::SiegeUniteLegale)
          common_network_error_request('INSEE', INSEE::SiegeUniteLegale)
        end
      end
    end
  end
end
