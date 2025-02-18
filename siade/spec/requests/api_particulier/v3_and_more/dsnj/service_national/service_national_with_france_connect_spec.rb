require 'swagger_helper'

RSpec.describe 'DSNJ: Service National With FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/dsnj/service_national/france_connect' do
    get SwaggerData.get('dsnj.service_national.title') do
      tags(*SwaggerData.get('dsnj.service_national.tags'))

      common_action_attributes

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      let(:scopes) { %i[dsnj_service_national] }

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
        end

        describe 'when identite is found' do
          # before do
          #    stub_dsnj_service_national_valid
          # end

          response '200', 'Identité trouvée', pending: 'Implement endpoint' do
            description SwaggerData.get('dsnj.service_national.description')

            rate_limit_headers

            schema build_rswag_response(
              attributes: SwaggerData.get('dsnj.service_national.attributes')
            )

            run_test!
          end
        end

        describe 'when identite is not found' do
          # before do
          #    stub_dsnj_service_national_not_found
          # end

          response '404', 'Non trouvée', pending: 'Implement endpoint' do
            build_rswag_example(NotFoundError.new('DSNJ'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          # TODO: Waiting FCv2 to be merge to provide error examples
        end
      end
    end
  end
end
