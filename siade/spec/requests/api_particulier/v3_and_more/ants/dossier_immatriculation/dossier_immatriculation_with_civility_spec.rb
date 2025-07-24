require 'swagger_helper'

RSpec.describe 'ANTS: Dossierimmatriculation With Civility', api: :particulier, type: %i[request swagger] do
  path '/v3/ants/dossier_immatriculation/identite' do
    get "[Identité] #{SwaggerData.get('ants.dossier_immatriculation.title')}" do
      tags(*SwaggerData.get('ants.dossier_immatriculation.tags'))

      common_action_attributes

      parameter name: :immatriculation,
        in: :query,
        type: SwaggerData.get('ants.dossier_immatriculation.parameters.immatriculation.type'),
        description: SwaggerData.get('ants.dossier_immatriculation.parameters.immatriculation.description'),
        example: SwaggerData.get('ants.dossier_immatriculation.parameters.immatriculation.example'),
        required: SwaggerData.get('ants.dossier_immatriculation.parameters.immatriculation.required')

      parameters_identite_pivot(
        params: %w[
          nomNaissance
          prenoms
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
          sexeEtatCivil
          codeCogInseeCommuneNaissance
          codeCogInseePaysNaissance
        ],
        required: %w[
          nomNaissance
          prenoms
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
          sexeEtatCivil
          codeCogInseePaysNaissance
        ]
      )

      let(:immatriculation) { 'AA-123-AA' }
      let(:nomNaissance) { 'Dupont' }
      let(:'prenoms[]') { %w[jean charlie] }
      let(:anneeDateNaissance) { 2008 }
      let(:moisDateNaissance) { 1 }
      let(:jourDateNaissance) { 1 }
      let(:codeCogInseePaysNaissance) { '99100' }
      let(:sexeEtatCivil) { 'M' }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(ANTS::DossierImmatriculation)

      let(:scopes) do
        %i[
          ants_dossier_immatriculation_statut_demandeur
          ants_dossier_immatriculation_statut_location
          ants_dossier_immatriculation_identite_demandeur
          ants_dossier_immatriculation_adresse_demandeur
          ants_dossier_immatriculation_immatriculation
          ants_dossier_immatriculation_vehicule
        ]
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Identité trouvée', pending: 'Implement endpoint' do
          before do
            allow(MockDataBackend).to receive(:get_response_for).and_return(nil)
          end

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

        describe 'server errors' do
          unprocessable_entity_error_request(:sexe_etat_civil) do
            let(:sexeEtatCivil) { 'lol' }
          end

          common_provider_errors_request('ANTS', ANTS::DossierImmatriculation)

          common_network_error_request('ANTS', ANTS::DossierImmatriculation)
        end
      end
    end
  end
end
