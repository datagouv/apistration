require 'swagger_helper'

RSpec.describe 'INSEE: Etablissement', api: :entreprise, type: %i[request swagger] do
  path '/v4/insee/sirene/etablissements/{siret}' do
    get SwaggerData.get('insee.etablissement_v4.title') do
      tags(*SwaggerData.get('insee.etablissement_v4.tags'))

      parameter_siret

      common_action_attributes

      unauthorized_request do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      too_many_requests(INSEE::Etablissement) do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Etablissement trouvé', vcr: { cassette_name: 'insee/siret/active_GE_with_token' } do
          description SwaggerData.get('insee.etablissement_v4.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('insee.etablissement_v4.attributes'),
            links: SwaggerData.get('insee.etablissement.links'),
            meta: SwaggerData.get('insee.etablissement.meta')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siret) { sirets_insee_v3[:active_GE] }

          unprocessable_content_error_request(:siret)

          response '404', 'Non trouvé', vcr: { cassette_name: 'insee/siret/non_existent_with_token' } do
            let(:siret) { non_existent_siret }

            build_rswag_example(NotFoundError.new('INSEE'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          response '451', 'Indisponible pour des raisons légales' do
            let(:siren) { sirens_insee_v3[:active_GE] }

            stubbed_organizer_error(
              INSEE::Etablissement,
              UnavailableForLegalReasonsError.new('INSEE', 'whatever')
            )

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('INSEE', INSEE::Etablissement)
          common_network_error_request('INSEE', INSEE::Etablissement)
        end
      end
    end
  end
end
