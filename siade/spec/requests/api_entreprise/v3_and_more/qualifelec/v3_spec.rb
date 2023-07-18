require 'swagger_helper'

RSpec.describe 'QualifElec: Qualification Electrique', api: :entreprise, type: %i[request swagger] do
  path '/v3/qualifelec/etablissements/{siret}/certificats' do
    get SwaggerData.get('qualifelec.certificats.title') do
      tags(*SwaggerData.get('qualifelec.certificats.tags'))

      parameter_siret

      common_action_attributes

      let(:siret) { valid_siret(:default) }

      too_many_requests(Qualifelec::Certificats) do
        let(:siret) { valid_siret(:default) }
      end

      describe 'with valid token and mandatory params', valid: true do
        describe 'with mocked data' do
          before do
            allow(MockService).to receive(:new).and_return(instance_double(MockService, mock: mocked_data))
          end

          response '200', 'Certificats qualifelec trouvés' do
            let(:mocked_data) do
              {
                status: 200,
                payload: {
                  meta: {
                    total: 0
                  },
                  data: [
                    OpenAPISchemaToExample.new(SwaggerData.get('qualifelec.certificats.attributes'))
                  ]
                }
              }
            end

            description SwaggerData.get('qualifelec.certificats.description')

            schema build_rswag_response_collection(
              properties: SwaggerData.get('qualifelec.certificats.attributes'),
              meta: SwaggerData.get('qualifelec.certificats.meta')
            )

            run_test!
          end

          response '404', 'Certificats entreprise inexistant.' do
            let(:mocked_data) do
              {
                status: 404,
                payload: {
                  errors: [
                    {
                      code: '404',
                      title: 'Entitée non trouvée',
                      detail: 'Certificats entrerprise inexistant. Le(s) document(s) ne peut être récupéré.',
                      meta: {}
                    }
                  ]
                }
              }
            end

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:rge_ademe) }

          unprocessable_entity_error_request(%i[siret])
          common_provider_errors_request('Qualifelec', Qualifelec::Certificats)
          common_network_error_request('Qualifelec', Qualifelec::Certificats)
        end
      end
    end
  end
end
