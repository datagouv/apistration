require 'swagger_helper'

RSpec.describe 'ANTS: Dossierimmatriculation With FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/ants/dossier_immatriculation/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('ants.dossier_immatriculation.title')}" do
      tags(*SwaggerData.get('ants.dossier_immatriculation.tags'))

      common_action_attributes

      parameter name: :immatriculation,
        in: :query,
        type: SwaggerData.get('ants.dossier_immatriculation.parameters.immatriculation.type'),
        description: SwaggerData.get('ants.dossier_immatriculation.parameters.immatriculation.description'),
        example: SwaggerData.get('ants.dossier_immatriculation.parameters.immatriculation.example'),
        required: SwaggerData.get('ants.dossier_immatriculation.parameters.immatriculation.required')

      let(:recipient) { valid_siret(:recipient) }
      let(:immatriculation) { 'AA-123-AA' }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      let(:scopes) do
        %i[
          ants_dossier_immatriculation_statut_demandeur
          ants_dossier_immatriculation_identite_demandeur
          ants_dossier_immatriculation_adresse_demandeur
          ants_dossier_immatriculation_immatriculation
          ants_dossier_immatriculation_vehicule
        ]
      end

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
          allow(MockDataBackend).to receive(:get_response_for).and_return(nil)
        end

        response '200', 'Identité trouvée', pending: 'Implement endpoint' do
          # before { stub_ants_dossier_immatriculation_found }

          description SwaggerData.get('ants.dossier_immatriculation.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('ants.dossier_immatriculation.attributes')
          )

          run_test!
        end

        describe 'when not found', pending: 'Get not found payload from FD' do
          before { stub_ants_dossier_immatriculation_not_found }

          response '404', 'Non trouvée' do
            build_rswag_example(NotFoundError.new('ANTS'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        # TODO: Waiting FCv2 to be merge to provide error examples
      end
    end
  end
end
