require 'swagger_helper'

RSpec.describe 'QualifElec: Qualification Electrique', api: :entreprise, type: %i[request swagger] do
  path '/v3/qualifelec/certificats/{siret}' do
    get SwaggerData.get('qualifelec.certificats.title') do
      tags(*SwaggerData.get('qualifelec.certificats.tags'))

      parameter_siret

      common_action_attributes

      let(:siret) { valid_siret(:qualibat) }

      let(:mocked_data) do
        {
          status: 200,
          payload: {}
        }
      end

      before do
        allow(MockService).to receive(:new).and_return(instance_double(MockService, mock: mocked_data))
      end

      describe 'with valid token and mandatory params', valid: true do
        response '200', 'Certificats qualifelec trouvés' do
          description SwaggerData.get('qualifelec.certificats.description')

          schema build_rswag_response_api_particulier(
            attributes: SwaggerData.get('qualifelec.certificats.attributes')
          )

          run_test!
        end
      end

      describe 'server errors' do
        response '400', 'Mauvais paramètres d\'appels' do
          let(:mocked_data) do
            {
              status: 400,
              payload: {
                error: 'bad_request',
                reason: 'Le siret est manquant',
                message: 'Le siret est manquant'
              }
            }
          end

          schema '$ref' => '#/components/schemas/Error'

          run_test!
        end

        response '404', 'Dossier entrerprise inexistant. Le document ne peut être récupéré.' do
          let(:mocked_data) do
            {
              status: 404,
              payload: {
                error: 'not_found',
                reason: 'Dossier allocataire inexistant. Le document ne peut être édité.',
                message: 'Dossier allocataire inexistant. Le document ne peut être édité.'
              }
            }
          end

          schema '$ref' => '#/components/schemas/Error'

          run_test!
        end

        response '500', 'Une erreur interne s\'est produite, l\'équipe a été prévenue.' do
          let(:mocked_data) do
            {
              status: 500,
              payload: {
                error: 'error',
                reason: 'Internal server error',
                message: "Une erreur interne s'est produite, l'équipe a été prévenue."
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
