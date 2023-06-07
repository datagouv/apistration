require 'swagger_helper'

RSpec.describe 'QualifElec: Qualification Electrique', api: :entreprise, type: %i[request swagger] do
  path '/v3/qualifelec/etablissements/{siret}/certificats' do
    get SwaggerData.get('qualifelec.certificats.title') do
      tags(*SwaggerData.get('qualifelec.certificats.tags'))

      parameter_siret

      common_action_attributes

      let(:siret) { valid_siret(:qualibat) }

      let(:mocked_data) do
        {
          status: 200,
          payload: {
            meta: {
              total: 0
            },
            data: []
          }
        }
      end

      describe 'with valid token and mandatory params', valid: true do
        before do
          allow(MockService).to receive(:new).and_return(instance_double(MockService, mock: mocked_data))
        end

        response '200', 'Certificats qualifelec trouvés' do
          description SwaggerData.get('qualifelec.certificats.description')

          schema build_rswag_response_collection(
            properties: SwaggerData.get('qualifelec.certificats.attributes'),
            meta: SwaggerData.get('qualifelec.certificats.meta')
          )

          run_test!
        end

        response '404', 'Certificats entrerprise inexistant.' do
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

        describe 'server errors' do
          response '422', 'Paramètre(s) invalide(s)' do
            let(:mocked_data) do
              {
                status: 422,
                payload: {
                  errors: [
                    {
                      code: '00210',
                      title: 'Entité non traitable',
                      detail: "Le paramètre recipient n'est pas un siret valide",
                      meta: {}
                    }
                  ]
                }
              }
            end

            unprocessable_entity_error_request(:siret)
          end

          response '500', 'Une erreur interne s\'est produite.' do
            let(:mocked_data) do
              {
                status: 500,
                payload: {
                  errors: [
                    {
                      code: '500',
                      title: 'Erreur interne',
                      detail: "Une erreur interne s'est produite, l'équipe a été prévenue.",
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
      end
    end
  end
end
