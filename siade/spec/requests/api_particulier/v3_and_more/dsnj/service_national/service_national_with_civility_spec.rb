require 'swagger_helper'

RSpec.describe 'DSNJ: Service National With Civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dsnj/service_national/identite' do
    get "[Identité] #{SwaggerData.get('dsnj.service_national.title')}" do
      tags(*SwaggerData.get('dsnj.service_national.tags'))

      common_action_attributes

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

      let(:nomNaissance) { 'Dupont' }
      let(:'prenoms[]') { %w[jean charlie] }
      let(:anneeDateNaissance) { 2008 }
      let(:moisDateNaissance) { 1 }
      let(:jourDateNaissance) { 1 }
      let(:codeCogInseePaysNaissance) { '99100' }
      let(:sexeEtatCivil) { 'M' }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(DSNJ::ServiceNational)

      let(:scopes) { %i[dsnj_statut_service_national] }

      describe 'with valid token and mandatory params', :valid do
        describe 'when found' do
          before { stub_dsnj_service_national_valid }

          response '200', 'Identité trouvée' do
            description SwaggerData.get('dsnj.service_national.description')

            rate_limit_headers

            schema build_rswag_response(
              attributes: SwaggerData.get('dsnj.service_national.attributes')
            )

            run_test!
          end
        end

        describe 'when not found' do
          before { stub_dsnj_service_national_not_found }

          response '404', 'Non trouvée' do
            build_rswag_example(NotFoundError.new('DSNJ'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'server errors' do
          unprocessable_content_error_request(:sexe_etat_civil) do
            let(:sexeEtatCivil) { 'lol' }
          end

          common_provider_errors_request('DSNJ', DSNJ::ServiceNational)

          common_network_error_request('DSNJ', DSNJ::ServiceNational)
        end
      end
    end
  end
end
